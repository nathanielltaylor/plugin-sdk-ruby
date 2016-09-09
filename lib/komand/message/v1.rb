module Komand
  module Message
    class V1
      TRIGGER_START = "trigger_start"
      ACTION_START = "action_start"
      TRIGGER_EVENT = "trigger_event"
      ACTION_EVENT = "action_event"

      VALID_TYPES = [TRIGGER_START, ACTION_START]

      SUCCESS = "ok"
      ERROR = "error"
      class << self

        def envelope(msg_type, body={})
          {
            "body"    => body,
            "type"    => msg_type,
            "version" => "v1",
          }
        end

        # This is a little helper to make selecting only the fields we care about a little simpler
        # We don't want people to provide data we didn't plan on using where possible
        # But, this is ruby, so like, nothing is gonna stop someone anyways
        def only(hsh,white_list)
          hsh.select {|k,_|white_list.include?(k)}
        end

        def action_start(opts={})
          envelope(ACTION_START, only(opts,["action","meta","input","connection"]))
        end

        def trigger_start(opts={})
          envelope(TRIGGER_START, only(opts, ["action","meta","input","dispatcher","connection"]))
        end

        def trigger_event(opts={})
          envelope(TRIGGER_EVENT, only(opts, ["meta","output"]))
        end

        def action_success(opts={})
          envelope(ACTION_EVENT, only(opts, ["meta","output"]).merge("status"=>SUCCESS))
        end

        def action_error(opts={})
          envelope(ACTION_EVENT, only(opts, ["meta","error"]).merge("status"=>ERROR))
        end

        def validate_trigger_start(body)
          raise ArgumentError.new("No body: #{body}") unless body
          raise ArgumentError.new("Missing trigger in #{body}") unless body["trigger"]
          body["connection"] ||= {}
          body["dispatcher"] ||= {}
          body["input"] ||= {}
        end

        def validate_action_start(body)
          raise ArgumentError.new("No body: #{body}") unless body
          raise ArgumentError.new("Missing action in #{body}") unless body["action"]
          body["connection"] ||= {}
          body["dispatcher"] ||= {}
          body["input"] ||= {}
        end

        def marshal(msg, file)
          data = json.dump(msg)
          if file
            File.open(file) { |f| f << data }
          else
            STDOUT << data
          end
        end

        def marshal_string(msg)
          json.dump(msg)
        end

        def unmarshal(reader)
          begin
            msg = if file
              reader.readlines
            else
              ARGF.inject("") {|d, line| d << line }
            end

            json.parse(msg)
            validate(msg)
            msg
          rescue => e
            raise ArgumentError.new("Invalid message json: #{e}")
          end
        end

        def validate(msg)
          raise ArgumentError.new("No message version: #{msg}") unless msg["version"]
          raise ArgumentError.new("Invalid version: #{msg['version']} in #{msg}") unless msg["version"] != VERSION
          raise ArgumentError.new("No message type: #{msg}") unless msg["type"]
          raise ArgumentError.new("Invalid type: #{msg['type']} in #{msg}") if VALID_TYPES.include?(msg["type"])
          raise ArgumentError.new("No message body: #{msg}") unless msg["body"]
          send("validate_#{msg['type']}")
        end
      end
    end
  end
end
