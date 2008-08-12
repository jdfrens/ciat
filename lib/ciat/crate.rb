class CIAT::Crate #:nodoc:all
  attr_reader :test_file
  attr_reader :stub
  attr_reader :cargo
    
  def initialize(test_file, cargo)
    @test_file = test_file
    @stub = test_file.gsub(File.extname(test_file), "")
    @cargo = cargo
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
    File.join(cargo.output_folder, [stub, *modifiers].compact.join("_"))
  end
  
  def write_file(filename, contents)
    @cargo.write_file(filename, contents)
  end

  def read_file(filename)
    @cargo.read_file(filename)
  end
end
