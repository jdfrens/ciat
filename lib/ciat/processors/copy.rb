module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      def initialize(original, copy, requireds)
        @original = original
        @copy = copy
        @requireds = requireds
      end
      
      def description
        'copier'
      end
      
      def process(crate)
        system "cp '#{crate.filename(@original)}' '#{crate.filename(@copy, :generated)}'"
      end
      
      def required_elements
        @requireds
      end
      
      def checked_files(crate)
        [crate.diff_filenames(@copy)]
      end
    end
  end
end