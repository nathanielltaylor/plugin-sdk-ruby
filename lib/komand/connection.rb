require 'json-schema'

module Komand
  class Connection
    attr_accessor :schema, :parameters
    def initialize(schema={})
      self.schema = schema
      self.parameters = {}
    end

    def set(params)
      self.parameters = params
      self.validate
    end

    def validate
      JSON::Validator.validate!(self.schema, self.parameters)
    end

    def connect(params={})
      raise NotImplementedError
    end

    def sample
      Komand::Util.sample(self.schema) if self.schema
    end
  end
end
