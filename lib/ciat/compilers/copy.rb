module CIAT
  module Compilers
    class Copy
      def compile(source, compilation_generated)
        system "cp '#{source}' '#{compilation_generated}'"
      end
    end
  end
end