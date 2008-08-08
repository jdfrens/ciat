module CIAT
  module Executors
    # An executor which simply cats a file into another one using the Unix
    # +cat+ command.
    class Cat
      def execute(compilation_generated, output_generated)
        system "cat '#{compilation_generated}' &> '#{output_generated}'"
      end
    end
  end
end