module CIAT
  module Executors
    class Cat
      def execute(compilation_generated, output_generated)
        system "cat '#{compilation_generated}' &> '#{output_generated}'"
      end
    end
  end
end