class CIAT::Crate #:nodoc:all
  attr_reader :test_file
  attr_reader :stub
  attr_reader :output_folder
    
  def initialize(test_file, output_folder)
    @test_file = test_file
    @output_folder = output_folder
  end
  
  def stub
    test_file.gsub(File.extname(test_file), "")
  end

  def filename(*modifiers)
    File.join(output_folder, [stub, *modifiers].compact.join("_"))
  end
  
  def read_test_file
    File.readlines(test_file)
  end  
  
  def process_test_file #:nodoc:
    elements = empty_elements_hash
    split_test_file.each do |name, contents|
      elements[name] = CIAT::TestElement.new(name, filename(name), contents)
    end
    elements
  end
  
  def split_test_file #:nodoc:
    tag = :description
    content = ""
    raw_elements = {}
    read_test_file.each do |line|
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
  
  #
  # Helpers
  #
  private
  
  def empty_elements_hash
    Hash.new do |hash, name|
      hash[name] = CIAT::TestElement.new(name, filename(name), nil)
    end
  end
end
