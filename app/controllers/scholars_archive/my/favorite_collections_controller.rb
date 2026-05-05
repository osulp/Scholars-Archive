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

        @favorite_collections = current_user.favorite_collections.map do |favorite|
          solr_doc = ::SolrDocument.find(favorite.collection_id)
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
    end
  end
end
