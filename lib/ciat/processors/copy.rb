module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      def initialize(original, copy)
        @original = original
        @copy = copy
      end
      
      def description
        "copy processor"
      end
      
      def process(crate)
        system "cp '#{crate.element(@original).as_file}' '#{crate.element(@copy).as_file}'"
      end
    end
  end
end
