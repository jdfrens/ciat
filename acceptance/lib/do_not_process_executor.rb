class DoNotProcessExecutor
  attr :light, true

  def initialize
    @light = CIAT::TrafficLight.new
  end
  
  def kind
    self
  end
  
  def describe
    "Should not be executed!"
  end
  
  def process(crate)
    raise("**** should not run this executor!!!")
  end
  
  def element_name_hash
    Hash.new([])
  end

  def relevant_elements(crate)
    []
  end
end
