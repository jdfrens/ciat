module CIAT
  module Processors
    # Processor used by CIAT::Test to actually run tests.  Also keeps track of results.
    class Magister
      attr_reader :light
      
      def initialize(processor)
        @processor = processor
        @light = CIAT::TrafficLight.new
      end
      
      def description(element=:description)
        @processor.description(element)
      end
      
      def process(crate)
        @processor.process(crate)
      end
      
      def required_elements
        @processor.required_elements
      end
      
      def optional_elements
        @processor.optional_elements
      end
      
      def checked_files(crate)
        @processor.checked_files(crate)
      end
    end
  end
end
