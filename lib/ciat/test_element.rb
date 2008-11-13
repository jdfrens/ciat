class CIAT::TestElement
  attr_reader :name
  
  def initialize(name, filename, content)
    @name = name
    @filename = filename
    @content = content
  end
  
  def content
    @content ||= CIAT::Cargo.read_file(@filename)
  end
  
  def as_file
    CIAT::Cargo.write_file(@filename, @content)
    @filename
  end
end
