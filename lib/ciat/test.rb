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
  
  def process_test_file
    @elements = @crate.process_test_file
  end

  def run_processors
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
  
  def report_lights
    processors.each do |processor|
      @feedback.processor_result(processor)
    end
  end  
end
