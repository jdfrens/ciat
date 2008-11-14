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
      include CIAT::Differs::HtmlDiffer

      # Traffic light
      attr_reader :light

      # Creates a Parrot executor.
      #
      # Possible options:
      # * <code>:description</code> is the description used in the HTML report 
      #   for this processor (default: <code>"Parrot virtual machine"</code>).
      # * <code>:command_line</code> is the description used in the HTML report
      #   for the command-line arguments (if any) (default: "Command-line arguments").
      def initialize(options={})
        @description = options[:description] || "Parrot virtual machine"
        @light = CIAT::TrafficLight.new
      end
      
      def describe
        @description
      end

      def process(crate)
        # TODO: verify required elements
        # TODO: handle optional element
        if execute(crate)
          if diff(crate)
            light.green!
          else
            light.red!
          end
        else
          light.yellow!
        end
        crate
      end
      
      def execute(crate)        
        system "parrot '#{crate.element(:compilation, :generated).as_file}' #{args(crate)} &> '#{crate.element(:execution, :generated).as_file}'"
      end
      
      def diff(crate)
        html_diff(crate.element(:execution).as_file, crate.element(:execution, :generated).as_file, crate.element(:execution, :diff).as_file)
      end

      def args(crate)
        (crate.element?(:command_line) ? crate.element(:command_line).content : '').strip
      end
    end
  end
end
