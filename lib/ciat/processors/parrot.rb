module CIAT
  module Processors
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
    # specifies the command-line arguments when the <code>compilation</code>
    # is executed.
    # If none is provided, no command-line arguments are used.
    class Parrot
      attr_accessor :kind
      attr_accessor :description
      attr_accessor :libraries

      # Creates a Parrot executor.
      #
      # Possible options:
      # * <code>:description</code> is the description used in the HTML report 
      #   for this processor (default: <code>"Parrot virtual machine"</code>).
      # * <code>:command_line</code> is the description used in the HTML
      #   report
      #   for the command-line arguments (if any) (default: "Command-line
      #   arguments").
      def initialize()
        self.kind = CIAT::Processors::Interpreter.new
        self.description = "Parrot virtual machine"
        self.libraries = []
        yield self if block_given?
      end
      
      # Provides a description of the processor.
      def describe
        @description
      end
      
      def executable
        (["parrot"] + @libraries.map { |library| "-L" + library }).join(" ")
      end
    end
  end
end
