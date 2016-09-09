module Komand
  class CLI
    GREEN = '\033[92m'
    RESET = '\033[0m'

    attr_accessor :plugin, :args, :message

    def initialize(plugin, args=ARGV.slice(1...ARGV.length))
      self.plugin = plugin
      self.args = args
    end
  end
end
