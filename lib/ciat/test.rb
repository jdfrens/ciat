require 'set'

class CIAT::Test
  attr_reader :filename
  attr_reader :processors
  attr_reader :elements

  def initialize(filename, elements, options={}) #:nodoc:
    @filename = filename
    @elements = elements
    @processors = options[:processors]
    @feedback = options[:feedback]
  end
  
  def run
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

  def element(*names)
    elements[names.compact.join("_").to_sym]
  end
  
  def element?(*names)
    elements.has_key?(names.compact.join("_").to_sym)
  end
end
