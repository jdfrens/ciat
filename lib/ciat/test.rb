require 'set'

class CIAT::Test
  attr_reader :crate
  attr_reader :processors
  attr_reader :elements

  def initialize(crate, options={}) #:nodoc:
    @crate = crate
    @processors = options[:processors]
    @differ = options[:differ] || CIAT::Differs::HtmlDiffer.new
    @feedback = options[:feedback]
    @elements = Hash.new { |hash, key| raise "#{key} not an expected element"}
  end
  
  def run
    process_test_file
    run_processors
    report_lights
    self
  end
  
  def process_test_file #:nodoc:
    @elements = @crate.process_test_file
    verify_required_elements
  end
  
  def verify_required_elements
    required = required_elements
    provided = provided_elements
    unless  required == provided
      if (required - provided).empty?
        raise "#{list_of_elements(provided - required)} from '#{@crate.test_file}' not used"
      else
        raise "#{list_of_elements(required - provided)} missing from '#{@crate.test_file}'"
      end
    end
  end

  def run_processors #:nodoc:
    @processors.each do |processor|
      process(processor)
      break unless processor.light.green?
    end
  end
  
  def process(processor) #:nodoc:
    if processor.process(crate)
      check(processor)
    else
      processor.light.yellow!
    end
  end
  
  def check(processor) #:nodoc:
    processor.checked_files(crate).each do |expected, generated, diff|
      unless @differ.diff(expected, generated, diff)
        processor.light.red!
      end
    end
    unless processor.light.red?
      processor.light.green!
    end
    processor.light
  end
  
  def report_lights #:nodoc:
    processors.each do |processor|
      @feedback.processor_result(processor)
    end
  end 
  
  def required_elements
    processors.map { |processor| processor.required_elements }.flatten.to_set + [:description]
  end
  
  def provided_elements
    elements.keys.to_set
  end
  
  private
  
  def list_of_elements(elements)
    elements.map { |e| "'" + e.to_s + "'" }.join(", ")
  end
end
