module CIAT
  class Filenames
    def initialize(basename)
      @basename = basename
    end
  
    def test_file
      filename("txt", current_directory)
    end
    
    def source
      filename("source")
    end

    def compilation_expected
      filename("compilation.expected")
    end

    def compilation_generated
      filename("compilation.generated")
    end

    def compilation_diff
      filename("compilation.diff")
    end

    def output_expected
      filename("output.expected")
    end

    def output_generated
      filename("output.generated")
    end

    def output_diff
      filename("output.diff")
    end
    
    def current_directory
      Dir.pwd
    end
  
    def temp_directory
      File.join(current_directory, "temp")
    end
  
    def filename(extension, directory = temp_directory)
      File.join(directory, "#{@basename}.#{extension}")
    end
  end
end