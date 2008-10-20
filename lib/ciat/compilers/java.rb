module CIAT
  module Compilers
    # Implements a compiler for CIAT::Suite which is written in Java.
    #
    # == Best Practices
    #   
    # Suppose you use Eclipse to develop your compiler or interpreter, and you
    # have this folder structure:
    # * +bin+ stored your compiled classes (under test)
    # * +lib+ support JAR files
    # * +acceptance+ a root folder for your CIAT tests with your +Rakefile+
    # You may find this classpath useful:
    #   Dir.glob('../lib/*.jar').join(':') + ":../bin"
    class Java
      # Constructs a compiler object.  +classpath+ is the complete classpath
      # to execute the compiler.  +compiler_class+ is the fullname of the
      # class that executes the compiler; this driver should take two
      # command-line arguments: the name of the source file and the name of
      # the generated target-code file.
      def initialize(classpath, compiler_class, options={})
        @classpath = classpath
        @compiler_class = compiler_class
        @descriptions = {
          :description => (options[:description] || "compiler")
          }
      end
      
      def description(element=:description)
        @descriptions[element]
      end
      
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
        [crate.diff_filenames(:compilation)]
      end
    end
  end
end