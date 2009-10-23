module CIAT
  module Compilers
    # Implements a processor written in Java.
    #
    # It requires <code>source</code> and <code>compilation</code> elements.
    # * <code>source</code> is used as source to the Java compiler.
    # * <code>compilation</code> is used for comparsion.
    #
    # == Best Practices
    #     
    # Suppose you use Eclipse to develop your compiler or interpreter, and you
    # have this folder structure:
    # * +bin+ stores your compiled classes (under test)
    # * +lib+ contains support JAR files
    # * +acceptance+ is a root folder for your CIAT tests with your +Rakefile+
    # You may find this classpath useful:
    #   Dir.glob('../lib/*.jar').join(':') + ":../bin"
    class Java
      include CIAT::Processors::BasicProcessing
      include CIAT::Differs::HtmlDiffer

      # The traffic light to indicate the success or failure of the processor.
      attr_accessor :light
      attr_accessor :processor_kind
      attr_accessor :compiler_class
      attr_accessor :descriptions
      attr_accessor :description
      
      # Constructs a "Java compiler" object.  +classpath+ is the complete
      # classpath to execute the compiler.  +compiler_class+ is the fully
      # qualified name of the class that executes your compiler; this driver
      # should take two command-line arguments: the name of the source file
      # and the name of the generated target-code file.
      #
      # Possible options:
      # * <code>description</code> specifies a descriptive name for your
      #   compiler; used in the HTML report.
      def initialize(classpath, compiler_class)
        @classpath = classpath
        @compiler_class = compiler_class
        self.processor_kind = CIAT::Processors::Compiler.new
        self.descriptions = {}
        self.description = "compiler (implemented in Java)"
        self.light = TrafficLight.new
        yield self if block_given?
      end

      # Return a description of the processor.
      def describe
        @description
      end
      
      def executable
        "java -cp '#{@classpath}' #{@compiler_class}"
      end
    end
  end
end
