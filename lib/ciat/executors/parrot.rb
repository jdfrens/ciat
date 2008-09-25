module CIAT
  module Executors
    # Executor class for Parrot programs.  This will execute PIR or PASM code
    # using the +parrot+ executable.
    class Parrot
      attr_reader :description
      
      def initialize(options={})
        @description = options[:description] || "Parrot virtual machine"
      end
      
      def process(crate)
        system "parrot '#{crate.filename(:compilation, :generated)}' &> '#{crate.filename(:execution, :generated)}'"
      end
      
      def checked_files(crate)
        [
          [crate.filename(:execution), crate.filename(:execution, :generated), crate.filename(:execution, :diff)]
          ]
      end
    end
  end
end
