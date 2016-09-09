module Komand
  module Util
    def default_for(prop)
      return prop['default'] if prop.key?('default')
      return prop['enum'][0] if prop['enum']

      case prop['type']
      when 'array'
        []
      when 'object'
        {}
      when 'string'
        ""
      when 'boolean'
        false
      when 'integer', 'number'
        0
      else
        ""
      end
    end

    def sample(source)
      return {} unless source || !source.key?("properties") || source["properties"].len == 0
      schema = {
        "title"=>"Example",
        "properties"=>{},
        "type"=>"object",
        "required"=>[],
      }

      defaults = {}

      source["properties"].each do |key,prop|
        defaults[key] = default_for(prop)
        schema["properties"][key] = prop
        schema["required"] << key
      end

      # Invoke the jsonschema builder here? Do we even need to? Maybe to validate it
    end
  end
end
