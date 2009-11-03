require 'set'
require 'ciat/test_result'
require 'ciat/subresult'

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
    CIAT::TestResult.new(self, run_processors)
  end
  
  def grouping
    @test_file.grouping
  end
  
  def run_processors #:nodoc:
    processors_iterator = processors.clone
    subresults = []
    until processors_iterator.empty?
      processor = processors_iterator.shift
      subresults << subresult(processor, processor.process(self))
      break unless subresults.last.light.green?
    end
    until processors_iterator.empty?
      processor = processors_iterator.shift
      subresults << subresult(processor)
    end
    subresults
  end
  
  def subresult(processor, light = CIAT::TrafficLight::UNSET)
    subresult = CIAT::Subresult.new(self,
      processor.path_kind(self), light, processor)
    @feedback.report_subresult(subresult)
    subresult
  end
  
  def element(*names)
    elements[names.compact.join("_").to_sym]
  end
  
  def element?(*names)
    elements.has_key?(names.compact.join("_").to_sym)
  end
end
