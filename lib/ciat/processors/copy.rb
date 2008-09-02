module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      def process(original, copy)
        system "cp '#{original}' '#{copy}'"
      end
    end
  end
end