require "yaml"

class CIAT::TestElement
  attr_reader :name
  
  def initialize(name, filename, content)
    @name = name
    @filename = filename
    @content = content
  end
  
  def template
    if yaml_entry.nil?
      raise "Need entry for #{name.to_s} in data/elements.yml"
    end
    File.join("elements", yaml_entry["template"])
  end
  
  def describe
    yaml_entry["description"]
  end
  
  def yaml_entry
    metadata[name.to_s]
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
  
  def metadata
    @@metadata ||= YAML.load_file(File.join(File.dirname(__FILE__), "..", "data", "elements.yml"))
  end
end
