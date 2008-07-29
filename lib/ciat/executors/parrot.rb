module CIAT
  module Executors
    # Executor class for Parrot programs.  This will execute PIR or PASM code
    # using the +parrot+ executable.
    class Parrot
      def run(compilation_generated, output_generated)
        system("parrot '#{compilation_generated}' &> '#{output_generated}'")
      end
    end
  end
end
