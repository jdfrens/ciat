module CIAT
  module Executors
    # Executor class for Java interpreters.
    #
    class Java
      include CIAT::Differs::HtmlDiffer

      # Traffic light
      attr :light, true

      # Creates a Java executor.
      #
      # Possible options:
      # * <code>:description</code> is the description used in the HTML report 
      #   for this processor (default: <code>"Parrot virtual machine"</code>).
      def initialize(classpath, interpreter_class, options={})
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
      
      # Runs the Java interpreter.
      def execute(crate)        
        system "java -cp '#{@classpath}' #{@interpreter_class} '#{crate.element(:source).as_file}' > '#{crate.element(:execution, :generated).as_file}' 2>&1"
      end
      
      # Compares the expected and generated executions.
      def diff(crate)
        html_diff(
          crate.element(:execution).as_file,
          crate.element(:execution, :generated).as_file, 
          crate.element(:execution, :diff).as_file)
      end
      
      # The interesting elements from this processor.
      def elements(crate)
        case light.setting
        when :green
          crate.elements(:source, :execution_generated)
        when :yellow
          crate.elements(:source, :execution_generated)
        when :red
          crate.elements(:source, :execution_diff)
        else
          raise "unexpected setting #{light.setting}"
        end
      end

    end
  end
end
