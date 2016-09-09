require 'komand/action/task'
module Komand
  class Action
    attr_accessor :name, :description, :input, :output, :connection

    def initialize(opts={})
      ["name","input","message","output"].each do |prop|
        self.send("#{prop}=",opts["prop"])
      end
    end

    def test
      raise NotImplementedError.new("test is not implemented")
    end

    def run
      raise NotImplementedError.new("test is not implemented")
    end
  end
end
