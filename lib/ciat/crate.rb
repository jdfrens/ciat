class CIAT::Crate #:nodoc:all
  attr_reader :test_file
  attr_reader :stub
  attr_reader :cargo
    
  def initialize(test_file, cargo)
    @test_file = test_file
    @stub = test_file.gsub(File.extname(test_file), "")
    @cargo = cargo
  end
  
  def process_test_file #:nodoc:
    write_output_files(split_test_file)
  end
  
  def split_test_file #:nodoc:
    tag = :description
    content = ""
    elements = {}
    File.readlines(test_file).each do |line|
      if line =~ /^==== (\w+)\W*$/
        elements[tag] = content
        tag = $1.to_sym
        content =""
      else
        content += line + "\n"
      end
    end
    elements[tag] = content
    elements
  end
  
  def write_output_files(elements)
    elements.each_pair do |key, element|
      write_file(filename(key), element)
    end
  end
    
  def test
    @test_file
  end

  def filename(*modifiers)
    File.join(cargo.output_folder, [stub, *modifiers].compact.join("_"))
  end
  
  def write_file(filename, contents)
    @cargo.write_file(filename, contents)
  end

  def read_file(filename)
    @cargo.read_file(filename)
  end
end
