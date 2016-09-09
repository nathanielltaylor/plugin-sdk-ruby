module Komand
  class Trigger
    class Task
      attr_accessor :connection, :trigger, :message, :dispatcher, :meta

      def initialize(opts={})
        ["connection","trigger","message","dispatcher","meta"].each do |prop|
          self.send("#{prop}=",prop)
        end
      end

      def submit(output) # Renamed from `send` in the other SDKs. Never name something `send` in ruby
        msg = Komand::Message::V1.trigger_event({"meta"=>self.meta,"output"=>output})
        self.dispatcher.write(msg)
      end

      def test
        begin
          self.setup(false)
          params = self.trigger&.input.parameters ? self.trigger&.input.parameters : {}
          output = self.trigger.test(params)

          msg = Komand::Message::V1.trigger_event({"meta"=>self.meta, "output"=>output})
          Komand::Dispatcher::Stdout.new.write(msg)
          true
        rescue => e
          puts "trigger test failure: #{e}"
          false
        end
      end

      def run
        begin
          self.setup
          self.trigger.sender = self
          params = self.trigger&.input.parameters ? self.trigger&.input.parameters : {}
          self.trigger.run(params)
        rescue => e
          puts "trigger test failure: #{e}"
        end
      end

      private
      def setup(validate=true)
        raise ArgumentError.new("No trigger input to trigger task") unless self.message
        self.dispatcher = Komand::Dispatcher::HTTP.new( self.message.dispatcher || {}) unless self.dispatcher
        self.meta = self.message.meta || {}
        if self.connection
          params = self.message.connection || {}
          self.connection.set(params)
          self.connection.connect(params)
          self.trigger.connection = self.connection
        end
        self.trigger.input.set(self.message.input, validate)
      end
    end
  end
end
