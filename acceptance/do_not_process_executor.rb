class DoNotProcessExecutor
  def describe
    "Should not be executed!"
  end
  
  def process(crate)
    raise("**** should not run this executor!!!")
  end

  def light
    CIAT::TrafficLight.new
  end
  
  def elements(crate)
    []
  end
end
