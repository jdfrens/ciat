class CIAT::TestElement
  attr_reader :name
  
  def initialize(name, filename, content)
    @name = name
    @filename = filename
    @content = content
  end
  
  def template
    File.join("elements", name.to_s)
  end
  
  def describe
    # TODO: a better definition!
    "Element named #{name}"
  end
  
  def content
    @content ||= CIAT::Cargo.read_file(@filename)
  end
  
  def as_file
    if @content
      CIAT::Cargo.write_file(@filename, @content)
    end
    @filename
  end
end
