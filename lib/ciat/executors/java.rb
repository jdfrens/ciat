module CIAT
  module Executors
    # Executor class for Java interpreters.
    #
    class Java
      include CIAT::Processors::BasicProcessing
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

      def executable
        "java -cp '#{@classpath}' #{@interpreter_class}"
      end
    end
  end
end
