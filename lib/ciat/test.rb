require 'set'
require 'ciat/test_result'
require 'ciat/subtest'
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
    subtests = make_subtests
    subresults = []
    until subtests.empty?
      subtest = subtests.shift
      subresults << subresult(subtest, subtest.process(@ciat_file))
      break unless subresults.last.light.green?
    end
    until subtests.empty?
      subresults << subresult(subtests.shift)
    end
    subresults
  end
  
  def make_subtests
    processors.map do |processor|
      CIAT::Subtest.new(@ciat_file, processor)
    end
  end
  
  def subresult(processor, light = CIAT::TrafficLight::UNSET)
    subresult = CIAT::Subresult.new(@ciat_file,
      processor.path_kind(@ciat_file), light, processor)
    @feedback.report_subresult(subresult)
    subresult
  end
end
