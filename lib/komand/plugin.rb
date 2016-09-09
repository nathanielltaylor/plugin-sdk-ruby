module Komand
  class Plugin
    attr_accessor :name, :vendor, :description, :version, :connection, :triggers, :actions, :debug
    def initialize(opts={})
      ["name","vendor","description","version","connection","triggers","actions"].each do |prop|
        self.send("#{prop}=",prop)
      end
    end

    def lookup(msg)
      case msg["type"]
      when Komand::Message::V1.TRIGGER_START
        Komand::Trigger::Task.new({
            "connection"=>self.connection,
            "trigger"=>self.trigger(msg["body"]),
            "message"=>msg["body"],
        })
      when Komand::Message::V1.ACTION_START
        Komand::Action::Task.new({
            "connection"=>self.connection,
            "trigger"=>self.action(msg["body"]),
            "message"=>msg["body"],
        })
      else
        raise ArgumentError.new("Invalid message type: #{msg['type']}")
      end
    end

    def test(msg=nil)
      input = msg ? StringIO.new(msg) : nil # defaults to stdin via ARGF in unmarshal
      msg = Komand::Message::V1.unmarshal(input)
      msg = Komand::Message::V1.unmarshal # Second attempt to read from it, I'm guessing if the incoming msg StringIO failed, we'll try again from stdin?
      exit 1 unless self.lookup(msg).test
    end

    def add_trigger(trigger)
      self.triggers[trigger.name]=trigger
    end

    def add_action(action)
      self.actions[action.name]=action
    end

    def trigger(msg)
      t = self.triggers[msg["trigger"]]
      raise ArgumentError.new("Trigger missing: #{msg['trigger']}") unless t
      t
    end

    def action(msg)
      a = self.actions[msg["action"]]
      raise ArgumentError.new("Action missing: #{msg['action']}") unless a
      a
    end
  end
end
