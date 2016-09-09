module Komand
  module Variables
    class Payload
      attr_accessor :schema, :parameters

      def initialize(schema)
        self.schema = schema
      end

      def set(params, validate=true)
        self.parameters = params
        self.validate!
      end

      def validate!

      end

      def sample

      end
    end

    class Input < Payload; end
    class Output <Payload; end
  end
end
