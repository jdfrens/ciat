module CIAT
  module Executors
    # Executor class for Parrot programs.  This will execute PIR or PASM code
    # using the +parrot+ executable.
    class Parrot
      def process(crate)
        system "parrot '#{crate.compilation_generated}' &> '#{crate.output_generated}'"
      end
    end
  end
end
