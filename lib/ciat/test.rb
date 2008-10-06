require 'set'

class CIAT::Test
  attr_reader :crate
  attr_reader :processors

  def initialize(crate, options={}) #:nodoc:
    @crate = crate
    @processors = options[:processors]
    @differ = options[:differ] || CIAT::Differs::HtmlDiffer.new
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
    verify_required_elements
  end
  
  def verify_required_elements
    required = required_elements
    optional = optional_elements
    provided = provided_elements
    if required.subset? provided
      if (provided - required).subset? optional
        true
      else
        extras = provided - required - optional
        raise "#{list_of_elements(extras)} from '#{@crate.test_file}' not used"
      end
    else
      raise "#{list_of_elements(required - provided)} missing from '#{@crate.test_file}'"
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
  
  def optional_elements
    processors.map { |processor| processor.optional_elements }.flatten.to_set
  end
  
  def provided_elements
    crate.provided_elements
  end
  
  private
  
  def list_of_elements(elements)
    elements.map { |e| "'" + e.to_s + "'" }.join(", ")
  end
end
