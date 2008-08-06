class CIAT::Crate
  attr_reader :test_file
  attr_reader :folder_name
  attr_reader :basename
  attr_reader :output_folder
    
  def initialize(test_file, output_folder)
    @test_file = test_file
    @folder_name = File.dirname(test_file)
    @basename = File.basename(test_file).gsub(File.extname(test_file), "")
    @output_folder = output_folder
  end
  
  def test
    @test_file
  end

  def source
    output_filename("source")
  end

  def compilation_expected
    output_filename("compilation", "expected")
  end

  def compilation_generated
    output_filename("compilation", "generated")
  end

  def compilation_diff
    output_filename("compilation", "diff")
  end

  def output_expected
    output_filename("output", "expected")
  end

  def output_generated
    output_filename("output", "generated")
  end

  def output_diff
    output_filename("output", "diff")
  end
  
  def output_filename(*modifiers)
    File.join(output_folder, [basename, *modifiers].compact.join("_"))
  end
end
