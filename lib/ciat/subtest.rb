require 'ciat/processors/basic_processing'

class CIAT::Subtest
  include CIAT::Processors::BasicProcessing
  
  attr_reader :light
  
  def initialize(test_file, processor)
    @test_file = test_file
    @processor = processor
    @light = CIAT::TrafficLight.new
  end
  
  def execute(test)
    @processor.execute(test)
  end
  
  def faux_execute(test)
    @processor.faux_execute(test)
  end
  
  def kind
    @processor.kind
  end
  
  def describe
    @processor.describe
  end
end