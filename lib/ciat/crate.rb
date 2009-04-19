class CIAT::Crate #:nodoc:all
  attr_reader :test_file
  attr_reader :stub
  attr_reader :output_folder
    
  def initialize(test_file, output_folder)
    @test_file = test_file
    @stub = test_file.gsub(File.extname(test_file), "")
    @output_folder = output_folder
  end

  def filename(*modifiers)
    File.join(output_folder, [stub, *modifiers].compact.join("_"))
  end
  
  def read_test_file
    File.readlines(test_file)
  end  
end
