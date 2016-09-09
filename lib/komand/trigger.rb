require 'komand/trigger/task'
module Komand
  class Trigger
    attr_accessor :name, :description, :connection, :sender, :input, :output
    def initialize(opts={})
      ["name","description","connection","sender","input","output"].each do |prop|
        self.send("#{prop}=",opts[prop])
      end
    end

    def submit(event) # Renamed from `send` in the other SDKs. Never name something `send` in ruby
      self.output.validate(event) if self.output
      self.sender.submit(event)
    end

    def run(params={})
      raise NotImplementedError.new
    end

    def test
      raise NotImplementedError.new
    end
  end
end
