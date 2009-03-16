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
      include CIAT::Differs::HtmlDiffer

      # The traffic light to indicate the success or failure of the processor.
      attr :light, true
      
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
        @descriptions = {}
        @description = options[:description] || "compiler (implemented in Java)"
        @light = options[:light] || TrafficLight.new
      end

      # Produces a clone for an individual test.
      def for_test
        copy = clone
        copy.light = light.clone
        copy
      end

      # Return a description of the processor.
      def describe
        @description
      end
      
      # Compiles the code and diffs the output.
      def process(crate)
        # TODO: verify required elements
        if compile(crate)
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

      # Does the actual compilation.
      def compile(crate)        
        system "java -cp '#{@classpath}' #{@compiler_class} '#{crate.element(:source).as_file}' '#{crate.element(:compilation, :generated).as_file}' 2> '#{crate.element(:compilation, :error).as_file}'"
      end
      
      # Computes the difference between the generated and expected output.
      def diff(crate)
        html_diff(
          crate.element(:compilation).as_file,
          crate.element(:compilation, :generated).as_file,
          crate.element(:compilation, :diff).as_file)
      end
      
      # The interesting elements of a Java processor based on the traffic light's
      # setting.
      def elements(crate)
        case light.setting
        when :green
          crate.elements(:source, :compilation)
        when :yellow
          crate.elements(:source, :compilation_error)
        when :red
          crate.elements(:source, :compilation_diff)
        else
          raise "unexpected setting #{light.setting}"
        end
      end
    end
  end
end
