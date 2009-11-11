module CIAT
  module Processors
    # Processor class for compilers and interpreters implemented in Java (or
    # on the JVM).
    #
    class Java
      attr_accessor :kind
      attr_accessor :description

      # Creates a Java executor.
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
