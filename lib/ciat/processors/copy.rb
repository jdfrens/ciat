module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      def initialize(original, copy, requireds, optionals=[])
        @original = original
        @copy = copy
        @requireds = requireds
        @optionals = optionals
      end
      
      def description(element=:description)
        case
        when element == :description
          'copier'
        when @optionals.includes?(element)
          "optional: #{element}"
        else
          nil
        end
      end
      
      def process(crate)
        system "cp '#{crate.filename(@original)}' '#{crate.filename(@copy, :generated)}'"
      end
      
      def required_elements
        @requireds
      end
      
      def optional_elements
        @optionals
      end
      
      def checked_files(crate)
        [crate.diff_filenames(@copy)]
      end
    end
  end
end