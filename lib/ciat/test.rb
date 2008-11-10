require 'set'

class CIAT::Test
  attr_reader :crate
  attr_reader :processors

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
  
  def process_test_file #:nodoc:
    @crate.process_test_file
  end
  
  def run_processors #:nodoc:
    @processors.each do |processor|
      processor.process(crate)
      break unless processor.light.green?
    end
  end
  
  def report_lights #:nodoc:
    processors.each do |processor|
      @feedback.processor_result(processor)
    end
  end 
end
