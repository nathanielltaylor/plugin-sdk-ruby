module Komand
  module Variables
    class Payload
      attr_accessor :schema, :parameters

      def initialize(schema)
        self.schema = schema
      end

      def set(params, validate=true)
        self.parameters = params
        self.validate if validate
      end

      def validate!
        JSON::Validator.validate!(self.schema, self.parameters) if schema
      end

      def sample
        Komand::Util.sample(self.schema)
      end
    end

    class Input < Payload; end
    class Output <Payload; end
  end
end
