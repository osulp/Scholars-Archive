module ScholarsArchive
	class FavoriteCollectionsController
		def create
			@favorite_collection = FavoriteCollection.new
			@favorite_collection.user_id = current_user.id
			@favorite_collection.collection_id = params[:collection_id]
			@favorite_collection.save!
		end
	end
end
