module CIAT
  module Processors
    # Processor used by CIAT::Test to actually run tests.  Also keeps track of results.
    class Magister
      def initialize(processor)
        @processor = processor
      end
      
      def description
        @processor.description
      end
      
      def process(crate)
        @processor.process(crate)
      end
      
      def checked_files(crate)
        @processor.checked_files(crate)
      end
    end
  end
end
