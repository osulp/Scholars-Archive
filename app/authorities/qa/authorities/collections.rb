module Qa::Authorities
  class Collections < Qa::Authorities::Base
    class_attribute :search_builder_class
    self.search_builder_class = Hyrax::CollectionSearchBuilder

    def search(_q, controller)
      # The Hyrax::CollectionSearchBuilder expects a current_user
      return [] unless controller.current_user
      repo = CatalogController.new.repository
      puts "REPO = #{repo}"
      builder = search_builder(controller)
      puts "BUILDER = #{builder.to_s}"
      response = repo.search(builder)
      puts "RESPONSE = #{response}"
      docs = response.documents
      docs.map do |doc|
        id = doc.id
        title = doc.title
        { id: id, label: title, value: id }
      end
    end

    private

      def search_builder(controller)
        access = controller.params[:access] || 'read'
        search_builder_class.new(controller)
                            .where(controller.params[:q])
                            .with_access(access)
                            .rows(100)
      end
  end
end