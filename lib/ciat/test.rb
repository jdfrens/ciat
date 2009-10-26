require 'set'
require 'ciat/test_result'
require 'ciat/subtest_result'

class CIAT::Test
  attr_reader :processors

  def initialize(test_file, processors, feedback) #:nodoc:
    @test_file = test_file
    @processors = processors
    @feedback = feedback
  end
  
  def elements
    @elements ||= @test_file.process
  end
  
  def filename
    @test_file.filename(:ciat)
  end
  
  def run
    @subresults = run_processors
    report_lights
    CIAT::TestResult.new(self, @subresults)
  end
  
  def grouping
    @test_file.grouping
  end
  
  def run_processors #:nodoc:
    previous = CIAT::TrafficLight.new(:green)
    processors.map do |processor|
      if previous.green?
        previous = processor.process(self)
        fail "whoa!" unless previous.class == CIAT::TrafficLight
        CIAT::SubtestResult.new(self, previous, processor)
      else
        CIAT::SubtestResult.new(self, CIAT::TrafficLight.new(:unset), processor)
      end
    end
  end
  
  def report_lights #:nodoc:
    @subresults.each do |subresult|
      # TODO: rename processor_result to subtest_result or finished_subtest
      @feedback.processor_result(subresult)
    end
  end

  def element(*names)
    elements[names.compact.join("_").to_sym]
  end
  
  def element?(*names)
    elements.has_key?(names.compact.join("_").to_sym)
  end
end
