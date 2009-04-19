require "yaml"

class CIAT::TestElement
  attr_reader :name
  
  def initialize(name, filename, content)
    @name = name
    @filename = filename
    @content = content
  end
  
  def template
    if descriptions[name.to_s].nil?
      raise "Need entry for #{name.to_s} in data/elements.yml"
    end
    File.join("elements", descriptions[name.to_s]["template"])
  end
  
  def describe
    descriptions[name.to_s]["description"]
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
  
  private
  
  def descriptions
    @@descriptions ||= YAML.load_file(File.join(File.dirname(__FILE__), "..", "data", "elements.yml"))
  end
end
