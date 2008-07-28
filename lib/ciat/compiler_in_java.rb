module CIAT
  # Implements a compiler for CIAT::Base.run_tests which is written in Java.
  class CompilerInJava
    # Constructs the compiler object.  +classpath+ is the complete classpath to execute the
    # compiler.  +compiler_class+ is the fullname of the class that executes the compiler; this driver
    # should take two command-line arguments: the name of the source file and the name of the generated
    # target-code file.
    def initialize(classpath, compiler_class)
      @classpath = classpath
      @compiler_class = compiler_class
    end
    
    # Compiles the source code into target code using the Java class and
    # classpath specified in the constructor.
    def compile(source_filename, target_filename)
      system "java -cp '#{@classpath}' #{@compiler_class} '#{source_filename}' '#{target_filename}'"
    end
  end
end