module ScholarsArchive
  module CollectionsHelper
    include Hyrax::CollectionsHelper

    def collection_brandable?(collection:)
      flash[:notice] = "To brand this collection, you must be an administrator. Please email through the contact form for branding assistance." unless current_user.admin?
      case collection
      when Valkyrie::Resource
        CollectionType
          .find_by_gid!(collection.collection_type_gid)
          .brandable? && current_user.admin?
      else
        collection.try(:brandable?) && current_user.admin?
      end
    end
  end
end