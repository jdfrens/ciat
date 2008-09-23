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
        'copier'
      end
      
      def process(crate)
        system "cp '#{crate.filename(@original)}' '#{crate.filename(@copy, :generated)}'"
      end
      
      def checked_files(crate)
        [
          [crate.filename(@copy), crate.filename(@copy, :generated), crate.filename(@copy, :diff)]
        ]
      end
    end
  end
end