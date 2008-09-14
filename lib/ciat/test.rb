class CIAT::Test
  attr_reader :crate
  attr_reader :processors
  attr_reader :elements
  attr_reader :lights

  def initialize(crate, options={}) #:nodoc:
    @crate = crate
    @processors = options[:processors]
    @differ = options[:differ] || CIAT::Differs::HtmlDiffer.new
    @lights = get_lights(options[:lights])
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
      break unless @lights[processor].green?
    end
  end
  
  def process(processor) #:nodoc:
    if processor.process(crate)
      check(processor)
    else
      @lights[processor].yellow!
    end
  end
  
  def check(processor) #:nodoc:
    processor.checked_files(crate).each do |expected, generated, diff|
      unless @differ.diff(expected, generated, diff)
        @lights[processor].red!
      end
    end
    unless @lights[processor].red?
      @lights[processor].green!
    end
    @lights[processor]
  end
  
  def report_lights
    processors.each do |processor|
      @feedback.processor_result(processor, lights[processor])
    end
  end
  
  private
  
  def get_lights(lights)
    if lights.nil?
      processors.inject({}) do |hash, processor|
        hash[processor] = CIAT::TrafficLight.new
        hash
      end
    else
      lights
    end
  end
  
end
