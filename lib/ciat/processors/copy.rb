module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      attr :light, true
      
      def initialize(original, copy)
        @original = original
        @copy = copy
        @light = CIAT::TrafficLight.new
      end
      
      def for_test
        copy = clone
        copy.light = light.clone
        copy
      end
      
      def describe
        "copy processor"
      end
      
      def process(crate)
        if system( "cp '#{crate.element(@original).as_file}' '#{crate.element(@copy).as_file}'")
          light.green!
        else
          light.red!
        end
      end
      
      def elements(crate)
        [@original, @copy].map { |e| crate.element(e) }
      end
    end
  end
end
