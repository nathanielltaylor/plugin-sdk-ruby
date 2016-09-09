module Komand
  class Util
    class << self

      def default_for_object(obj, defs)
        return {} unless obj['properties']
        obj['properties'].inject({}) {|hsh, (k,v)| hsh[k] = default_for(v); hsh}
      end

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
        when 'enum'
          prop['enum'][0]
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

        definitions = {}
        if source['definitions']
          schema['definitions'] = source['definitions']

          definitions = schema["definitions"].inject({}) {|hsh, (k,v)| hsh["#/definitions/#{k}"] = v; hsh}
        end

        defaults = default_for_object(source, definitions)

        source["properties"].each do |key,prop|
          schema["properties"][key] = prop
          schema["required"] << key
        end

        defaults
      end
    end
  end
end
