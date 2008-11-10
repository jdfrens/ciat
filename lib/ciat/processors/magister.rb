module CIAT
  module Processors
    # Processor used by CIAT::Test to actually run tests.  Also keeps track of results.
    class Magister
      attr_reader :light
      
      def initialize(processor)
        @processor = processor
        @light = CIAT::TrafficLight.new
      end
      
      def description
        @processor.description
      end
      
      def process(crate)
        @processor.process(crate)
      end
    end
  end
end
