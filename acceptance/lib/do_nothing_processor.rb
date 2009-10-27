class DoNothingProcessor
  attr :light, true
  
  def initialize(setting)
    @light = CIAT::TrafficLight.new(setting)
  end

  def kind
    self
  end
  
  def describe
    "Do-Nothing Processor with #{light.setting} light"
  end
  
  def process(test)
    @light
  end
  
  def element_name_hash
    Hash.new([])
  end
  
  def relevant_elements(crate)
    # TODO: maybe return an element?
    []
  end
end
