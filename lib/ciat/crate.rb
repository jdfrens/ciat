class CIAT::Crate #:nodoc:all
  attr_reader :test_file
  attr_reader :stub
  attr_reader :cargo
    
  def initialize(test_file, cargo, elements={})
    @test_file = test_file
    @stub = test_file.gsub(File.extname(test_file), "")
    @cargo = cargo
    @elements = elements
  end
  
  def process_test_file #:nodoc:
    @elements = Hash.new { |hash, name| hash[name] = CIAT::TestElement.new(name, filename(name), nil) }
    split_test_file.each do |name, contents|
      @elements[name] = CIAT::TestElement.new(name, filename(name), contents)
    end
    @elements
  end
  
  def split_test_file #:nodoc:
    tag = :description
    content = ""
    raw_elements = {}
    File.readlines(test_file).each do |line|
      if line =~ /^==== ((\w|\s)+?)\W*$/
        raw_elements[tag] = content
        tag = $1.gsub(" ", "_").to_sym
        content = ""
      else
        content += line
      end
    end
    raw_elements[tag] = content
    raw_elements
  end
  
  def element(*names)
    @elements[names.compact.join("_").to_sym]
  end
  
  def element?(*names)
    @elements.has_key?(names.compact.join("_").to_sym)
  end
  
  def elements(*names)
    names.map { |name| element(name) }
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
