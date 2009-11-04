class CIAT::CiatFile #:nodoc:all
    
  def initialize(ciat_file, output_folder)
    unless File.exists?(ciat_file)
      raise IOError.new(ciat_file + " does not exist")
    end
    @ciat_file = ciat_file
    @output_folder = output_folder
  end

  def elements
    @elements ||= process
  end
  
  def element(*names)
    elements[names.compact.join("_").to_sym]
  end
  
  def element?(*names)
    elements.has_key?(names.compact.join("_").to_sym)
  end

  def filename(*modifiers)
    if modifiers == [:ciat]
      @ciat_file
    else
      File.join(@output_folder, [stub, *modifiers].compact.join("_"))
    end
  end
  
  def grouping
    File.dirname(@ciat_file)
  end
  
  def process #:nodoc:
    elements = empty_elements_hash
    split.each do |name, contents|
      elements[name] = CIAT::TestElement.new(name, filename(name), contents)
    end
    elements
  end
  
  def split #:nodoc:
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
    File.readlines(@ciat_file)
  end  
  
  def empty_elements_hash
    Hash.new do |hash, name|
      hash[name] = CIAT::TestElement.new(name, filename(name), nil)
    end
  end
  
  def stub
    @ciat_file.gsub(File.extname(@ciat_file), "")
  end
end
