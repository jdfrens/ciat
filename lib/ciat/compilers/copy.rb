module CIAT
  module Compilers
    # A simple "compiler" that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      def compile(source, compilation_generated)
        system "cp '#{source}' '#{compilation_generated}'"
      end
    end
  end
end