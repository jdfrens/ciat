class DoNothingProcessor
  attr_reader :light
  
  def initialize(setting)
    @light = CIAT::TrafficLight.new(setting)
  end
  
  def describe
    "Do-Nothing Processor with #{light.setting} light"
  end
  
  def process(crate)
    crate
  end
  
  def elements(crate)
    # TODO: maybe return an element?
    []
  end
end
