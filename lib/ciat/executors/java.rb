module CIAT
  module Executors
    # Executor class for Java interpreters.
    #
    class Java
      include CIAT::Differs::HtmlDiffer

      # Traffic light
      attr :light, true
      attr_reader :processor_kind

      # Creates a Java executor.
      #
      # Possible options:
      # * <code>:description</code> is the description used in the HTML report 
      #   for this processor (default: <code>"Parrot virtual machine"</code>).
      def initialize(classpath, interpreter_class, options={})
        @processor_kind = options[:processor_kind] || CIAT::Processors::Interpreter.new
        @classpath = classpath
        @interpreter_class = interpreter_class
        @description = options[:description] || "in-Java interpreter"
        @light = CIAT::TrafficLight.new
      end
      
      # Produces a clone for an individual test.
      def for_test
        copy = clone
        copy.light = light.clone
        copy
      end
      
      # Provides a description of the processor.
      def describe
        @description
      end

      # Executes the program, and diffs the output.
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
      
      def executable
        "java -cp '#{@classpath}' #{@interpreter_class}"
      end

      # Compares the expected and generated executions.
      def diff(crate)
        html_diff(
          crate.element(:execution).as_file,
          crate.element(:execution, :generated).as_file, 
          crate.element(:execution, :diff).as_file)
      end

      include CIAT::Processors::BasicProcessing
    end
  end
end
