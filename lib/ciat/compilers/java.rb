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
      # Constructs a "Java compiler" object.  +classpath+ is the complete
      # classpath to execute the compiler.  +compiler_class+ is the fully
      # qualified name of the class that executes your compiler; this driver
      # should take two command-line arguments: the name of the source file
      # and the name of the generated target-code file.
      #
      # Possible options:
      # * <code>description</code> specifies a descriptive name for your
      #   compiler; used in the HTML report.
      def initialize(classpath, compiler_class, options={})
        @classpath = classpath
        @compiler_class = compiler_class
        @descriptions = {
          :description => (options[:description] || "compiler")
          }
      end
      
      # Description of the compiler-implemented-in-Java.
      def description(element=:description)
        @descriptions[element]
      end
      
      # Runs the compiler-implemented-in-Java.
      def process(crate)
        system "java -cp '#{@classpath}' #{@compiler_class} '#{crate.filename(:source)}' '#{crate.filename(:compilation, :generated)}'"
      end

      def required_elements
        [:source, :compilation]
      end
      
      def optional_elements
        []
      end
      
      def checked_files(crate)
        CIAT::CheckedFile.create(crate, :compilation)
      end
    end
  end
end
