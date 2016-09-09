module Komand
  module Dispatcher
    class Stdout
      def write(object)
        Komand::Message::V1.marshal(object)
      end
    end
  end
end
