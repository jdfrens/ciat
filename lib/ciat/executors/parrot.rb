module CIAT
  module Executors
    # Executor class for Parrot programs.  This will execute PIR or PASM code
    # using the +parrot+ executable.
    class Parrot
      def initialize(options={})
        @descriptions = { 
          :description => (options[:description] || "Parrot virtual machine"),
          :command_line => "Command-line arguments"
          }
      end
      
      def description(element = :description)
        @descriptions[element]
      end
      
      def process(crate)
        args = crate.element(:command_line) || ''
        system "parrot '#{crate.filename(:compilation, :generated)}' #{args.strip} &> '#{crate.filename(:execution, :generated)}'"
      end
      
      def required_elements
        [:execution]
      end
      
      def optional_elements
        [:command_line]
      end
      
      def checked_files(crate)
        CIAT::CheckedFile.create(crate, :execution)
      end
    end
  end
end
