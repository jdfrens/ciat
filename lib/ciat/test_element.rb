class CIAT::TestElement
  attr_reader :name
  attr_reader :content
  
  def initialize(name, filename, content)
    @filename = filename
    @content = content
  end
  
  def as_file
    CIAT::Cargo.write_file(@filename, @content)
    @filename
  end
end
