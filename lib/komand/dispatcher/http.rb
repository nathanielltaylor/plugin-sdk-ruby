require 'faraday'

module Komand
  module Dispatcher
    class HTTP
      attr_accessor :url
      def initialize(opts={})
        raise ArgumentError.new("missing HTTP dispatcher conifg") unless opts
        raise ArgumentError.new("missing HTTP dispatcher config url") unless opts["url"]
        puts "Using dispatcher config #{opts}"
      end

      def write(object)
        # TODO cache the connection and break up the url into root and route
        Faraday.post(self.url,object)
      end
    end
  end
end
