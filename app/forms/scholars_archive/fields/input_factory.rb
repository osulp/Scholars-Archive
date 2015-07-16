module ScholarsArchive
  module Fields
    class InputFactory
      pattr_initialize :base_factory, :decorator

      def create(object, property)
        decorate do
          base_factory.create(object, property)
        end
      end

      private

      def decorate
        decorator.new(yield)
      end
    end
  end
end
