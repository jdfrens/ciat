class CIAT::TestFile #:nodoc:all
    
  def initialize(test_file, output_folder)
    @test_file = test_file
    @output_folder = output_folder
  end

  def filename(*modifiers)
    if modifiers == [:ciat]
      @test_file
    else
      File.join(@output_folder, [stub, *modifiers].compact.join("_"))
    end
  end
  
  def grouping
    File.dirname(@test_file)
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
    read.each do |line|
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
  
  def read
    File.readlines(@test_file)
  end  
  
  def empty_elements_hash
    Hash.new do |hash, name|
      hash[name] = CIAT::TestElement.new(name, filename(name), nil)
    end
  end
  
  def stub
    @test_file.gsub(File.extname(@test_file), "")
  end
end
