require 'set'
require 'ciat/test_result'
require 'ciat/subresult'

class CIAT::Test
  attr_reader :processors

  def initialize(ciat_file, processors, feedback) #:nodoc:
    @ciat_file = ciat_file
    @processors = processors
    @feedback = feedback
  end
    
  def run
    CIAT::TestResult.new(@ciat_file, run_subtests)
  end
  
  def grouping
    @ciat_file.grouping
  end
  
  def run_subtests #:nodoc:
    processors_iterator = processors.clone
    subresults = []
    until processors_iterator.empty?
      processor = processors_iterator.shift
      subresults << subresult(processor, processor.process(@ciat_file))
      break unless subresults.last.light.green?
    end
    until processors_iterator.empty?
      processor = processors_iterator.shift
      subresults << subresult(processor)
    end
    subresults
  end
  
  def subresult(processor, light = CIAT::TrafficLight::UNSET)
    subresult = CIAT::Subresult.new(@ciat_file,
      processor.path_kind(@ciat_file), light, processor)
    @feedback.report_subresult(subresult)
    subresult
  end
end
