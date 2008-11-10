class CIAT::TestElement
  def initialize(filename, content)
    @filename = filename
    @content = content
  end
  
  def as_file
    CIAT::Cargo.write_file(@filename, @content)
    @filename
  end
end
