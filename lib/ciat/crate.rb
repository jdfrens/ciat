class CIAT::Crate #:nodoc:all
  attr_reader :test_file
  attr_reader :stub
    
  def initialize(test_file, output_folder, elements={})
    @test_file = test_file
    @stub = test_file.gsub(File.extname(test_file), "")
    @output_folder = output_folder
    @elements = elements
  end
  
  # TODO: move to TestElement as class method
  def process_test_file #:nodoc:
    @elements = Hash.new { |hash, name| hash[name] = CIAT::TestElement.new(name, filename(name), nil) }
    split_test_file.each do |name, contents|
      @elements[name] = CIAT::TestElement.new(name, filename(name), contents)
    end
    @elements
  end
  
  # TODO: move to TestElement as class method
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
  
  # TODO: Move to Test
  def element(*names)
    @elements[names.compact.join("_").to_sym]
  end
  
  # TODO: Move to Test
  def element?(*names)
    @elements.has_key?(names.compact.join("_").to_sym)
  end
  
  # TODO: Move to Test
  def elements(*names)
    names.map { |name| element(name) }
  end
  
  # TODO: move to TestElement, class or instance?
  def filename(*modifiers)
    File.join(@output_folder, [stub, *modifiers].compact.join("_"))
  end
end
