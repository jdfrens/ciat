module CIAT #:nodoc: all
  class Filenames
    def initialize(filename)
      @filename = filename
    end
  
    def test_file
      @filename + ".txt"
    end

    def hobbes_source
      work_directory + "/" + @filename + ".hob"
    end

    def expected_pir
      work_directory + "/" + @filename + "_expected.pir"
    end

    def generated_pir
      work_directory + "/" + @filename + "_generated.pir"
    end

    def expected_output
      work_directory + "/" + @filename + "_expected.out"
    end

    def generated_output
      work_directory + "/" + @filename + "_generated.out"
    end

    def pir_diff
      work_directory + "/" + @filename + "_pir.diff"
    end

    def output_diff
      work_directory + "/" + @filename + "_output.diff"
    end
    
    def work_directory
      "./work"
    end
  end
end