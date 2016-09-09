require 'json-schema'

module Komand
  class Action
    class Task
      attr_accessor :action, :message, :dispatcher, :meta, :connection

      def initialize(opts={})
        self.action = opts["action"]
        self.connection = opts["connection"]
        self.dispatcher = opts["dispatcher"] || Komand::Dispatcher::Stdout.new
        self.message = opts["message"]
      end

      def test
        begin
          self.setup
          params = self.action&.input.parameters || {}
          output = self.action.test(params) # The above line implies action could be nil, but we go ahead and use it anyways after... exceptions as code flow?
          schema = self.action.output.schema
          JSON::Validator.validate!(schema, output) if schema
          ok = Komand::Message::V1.action_success({"meta"=>self.meta,"output"=>output})
          self.dispatcher.write(ok)
          true
        rescue => e
          puts "Action test failure: #{e} #{e.backtrace}"
          err = Komand::Message::V1.action_error({"meta"=>self.meta,"error"=>e.to_s})
          self.dispatcher.write(err)
          false
        end
      end

      def run
        begin
          self.setup
          params = self.action&.input.parameters || {}
          output = self.action.run(params)
          schema = self.action.output
          JSON::Validator.validate!(schema, output) if schema
          ok = Komand::Message.action_success({"meta"=>self.meta,"output"=>output})
          self.dispatcher.write(ok)
        rescue => e
          puts "Action run failure: {e}"
          err = Komand::Message.action_error({"meta"=>self.meta,"error"=>e.to_s})
          self.dispatcher.write(err)
          false
        end
      end

      def setup
        raise ArgumentError.new("No action input to action task") unless self.message
        self.meta = self.message["meta"] || {}
        if self.connection
          params = self.message["connection"] || {}
          self.connection.set(params)
          self.connection.connect(params)
          self.action.connection = self.connection
        end
        self.action.input.set(self.message["body"]["input"]) if self.action.input
      end
    end
  end
end
