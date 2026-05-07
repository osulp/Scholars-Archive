# frozen_string_literal: true

module ScholarsArchive
  module My
    # CLASS: My Favorite Collections Controller
    class FavoriteCollectionsController < Hyrax::My::CollectionsController
      # Authenticate user to know that user must sign in
      before_action :authenticate_user!

      # METHOD: Index page load all the collection found in favorite
      def index
        add_breadcrumb t(:'hyrax.controls.home'), root_path
        add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
        add_breadcrumb t(:'hyrax.admin.sidebar.collections'), hyrax.my_collections_path

        # GET: Get all the favorite_collections
        @favorite_collections = current_user.favorite_collections.map do |favorite|
          solr_doc = ::SolrDocument.find(favorite.collection_id)

          # Skip admin sets, only show regular collections
          next if solr_doc.admin_set?

          Hyrax::CollectionPresenter.new(solr_doc, current_ability)
        rescue Blacklight::Exceptions::RecordNotFound
          nil
        end.compact
      end

      # METHOD: The create method add item into the favorite tab
      def create
        current_user.favorite_collections.find_or_create_by!(collection_id: params[:collection_id])
        redirect_back fallback_location: root_path, notice: 'Collection was added to Favorites.'
      end

      # METHOD: The destroy method remove item into the favorite tab
      def destroy
        favorite = current_user.favorite_collections.find_by(collection_id: params[:collection_id])
        favorite&.destroy
        redirect_back fallback_location: root_path, notice: 'Collection was removed from Favorites.'
      end

      private

      # METHOD: To add filter to the favorite collections
      def search_action_url(*args)
        Rails.application.routes.url_helpers.my_favorite_collections_url(*args)
      end

      # OVERRIDE: Override to limit Blacklight search to only favorited collection IDs
      def search_builder
        favorite_ids = current_user.favorite_collections.pluck(:collection_id)
        super.tap do |builder|
          builder.with(fq: "id:(#{favorite_ids.join(' OR ')})")
        end
      end
    end
  end
end
