module CIAT
  module Executors
    # Executor class for Java interpreters.
    #
    class Java
      include CIAT::Processors::BasicProcessing

      # Traffic light
      attr_accessor :kind
      attr_accessor :description

      # Creates a Java executor.
      #
      # Possible options:
      # * <code>:description</code> is the description used in the HTML report 
      #   for this processor (default: <code>"Parrot virtual machine"</code>).
      def initialize(classpath, interpreter_class)
        @classpath = classpath
        @interpreter_class = interpreter_class
        self.kind = CIAT::Processors::Interpreter.new
        self.description = "in-Java interpreter"
        yield self if block_given?
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
