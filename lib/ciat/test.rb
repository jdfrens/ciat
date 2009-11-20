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
      subresults << subresult(subtest, subtest.process)
      if subtest.sad_path?
        return subresults + remaining_subtests(subtests, unneeded)
      end
      unless subresults.last.light.green?
        return subresults + remaining_subtests(subtests, unset)
      end
    end
    subresults
  end

  def remaining_subtests(subtests, light)
    subtests.map { |subtest| subresult(subtest, light) }
  end
  
  def unneeded
    CIAT::TrafficLight::UNNEEDED
  end
  
  def unset
    CIAT::TrafficLight::UNSET
  end
  
  def make_subtests
    processors.map do |processor|
      CIAT::Subtest.new(@ciat_file, processor)
    end
  end
  
  def subresult(subtest, light)
    subresult = CIAT::Subresult.new(@ciat_file,
      subtest.path_kind, light, subtest)
    @feedback.report_subresult(subresult)
    subresult
  end
end
