require 'set'

class CIAT::Test
  attr_reader :crate
  attr_reader :processors
  attr_reader :elements

  def initialize(crate, options={}) #:nodoc:
    @crate = crate
    @processors = options[:processors]
    @feedback = options[:feedback]
  end
  
  def run
    process_test_file
    run_processors
    report_lights
    self
  end
  
  def run_processors #:nodoc:
    processors.each do |processor|
      processor.process(self)
      break unless processor.light.green?
    end
  end
  
  def report_lights #:nodoc:
    processors.each do |processor|
      @feedback.processor_result(processor)
    end
  end
  
  def process_test_file #:nodoc:
    @elements = Hash.new { |hash, name| hash[name] = CIAT::TestElement.new(name, crate.filename(name), nil) }
    split_test_file.each do |name, contents|
      @elements[name] = CIAT::TestElement.new(name, crate.filename(name), contents)
    end
    @elements
  end
  
  def split_test_file #:nodoc:
    tag = :description
    content = ""
    raw_elements = {}
    crate.read_test_file.each do |line|
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

  def element(*names)
    elements[names.compact.join("_").to_sym]
  end
  
  def element?(*names)
    elements.has_key?(names.compact.join("_").to_sym)
  end
end
