module ScholarsArchive
  class DefaultMiddlewareStack < Hyrax::DefaultMiddlewareStack
    def self.build_sa_stack
      # insert our our custom actor after the last actor in the hyrax default middleware stack
      sa_middlewares = build_stack.insert_after build_stack.last.klass, ScholarsArchive::Actors::AddOtherFieldOptionActor
      sa_stack = ActionDispatch::MiddlewareStack.new
      sa_stack.middlewares = sa_middlewares
      sa_stack
    end
  end
end