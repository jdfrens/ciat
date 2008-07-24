module CIAT
  class CompilerInJava
    def initialize(classpath, compiler_class)
      @classpath = classpath
      @compiler_class = compiler_class
    end
    
    def compile(hobbes_source, generated_pir)
      system "java -cp '#{@classpath}' #{@compiler_class} '#{hobbes_source}' '#{generated_pir}'"
    end
  end
end