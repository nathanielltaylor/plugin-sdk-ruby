require 'komand/action/task'

module Komand
  class Action
    attr_accessor :name, :description, :input, :output, :connection, :message

    def initialize(opts={})
      ["name","description","input","message","output"].each do |prop|
        self.send("#{prop}=",opts[prop]) if opts[prop]
      end
    end

    def test(params={})
      raise NotImplementedError.new("test is not implemented")
    end

    def run(params={})
      raise NotImplementedError.new("test is not implemented")
    end
  end
end
