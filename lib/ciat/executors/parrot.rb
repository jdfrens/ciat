module CIAT
  module Executors
    # Executor class for Parrot programs.  This will execute PIR or PASM code
    # using the +parrot+ executable.
    #
    # The Parrot executor expects <code>compilation</code> and
    # <code>execution</code> elements.  The <code>compilation</code> element
    # is used as input (and it actually pulls in the generated version, but it
    # should be the same as the expected).  <code>execution</code> is
    # compared.
    #
    # The Parrot executor allows for a <code>command line</code> element.  This
    # specifies the command-line arguments when the <code>compilation</code> is executed.
    # If none is provided, no command-line arguments are used.
    class Parrot
      # Creates a Parrot executor.
      #
      # Possible options:
      # * <code>:description</code> is the description used in the HTML report 
      #   for this processor (default: <code>"Parrot virtual machine"</code>).
      # * <code>:command_line</code> is the description used in the HTML report
      #   for the command-line arguments (if any) (default: "Command-line arguments").
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
        system "parrot '#{crate.filename(:compilation, :generated)}' #{args(crate)} &> '#{crate.filename(:execution, :generated)}'"
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
      
      private
      
      def args(crate)
        (crate.element(:command_line) || '').strip
      end
    end
  end
end
