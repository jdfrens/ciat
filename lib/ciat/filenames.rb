module CIAT
  class Filenames
    attr_reader :test_file
    
    def initialize(test_file)
      @test_file = test_file
      @basename = File.basename(test_file).gsub(File.extname(test_file), "")
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
    
    def filename(extension, directory = temp_directory)
      File.join(directory, "#{@basename}.#{extension}")
    end
    
    def current_directory
      self.class.current_directory
    end
  
    def temp_directory
      self.class.temp_directory
    end
  
    def self.current_directory
      Dir.pwd
    end
  
    def self.temp_directory
      File.join(current_directory, "temp")
    end
  end
end