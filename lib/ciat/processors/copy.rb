module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      def initialize(original, copy)
        @original = original
        @copy = copy
      end
      
      def process(crate)
        system "cp '#{crate.filename(@original)}' '#{crate.filename(@copy)}'"
      end
    end
  end
end