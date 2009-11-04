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
  
  def happy_path?(test)
    true
  end
  
  def path_kind(test)
    :happy
  end
  
  def process(test)
    @light
  end
  
  def element_name_hash
    Hash.new([])
  end
  
  def relevant_elements(ignored)
    []
  end
end
