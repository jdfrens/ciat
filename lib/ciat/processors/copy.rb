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
      
      def process(test_file)
        if system( "cp '#{test_file.element(@original).as_file}' '#{test_file.element(@copy).as_file}'")
          light.green!
        else
          light.red!
        end
      end
      
      def relevant_elements(test_file)
        [@original, @copy].map { |e| test_file.element(e) }
      end
    end
  end
end
