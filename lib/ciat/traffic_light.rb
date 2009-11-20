class CIAT::TrafficLight
  
  def initialize(setting) #:nodoc:
    @setting = setting
  end
  
  GREEN = CIAT::TrafficLight.new(:green)
  RED = CIAT::TrafficLight.new(:red)
  YELLOW = CIAT::TrafficLight.new(:yellow)
  UNSET = CIAT::TrafficLight.new(:unset)
  UNNEEDED = CIAT::TrafficLight.new(:unneeded)
  
  def unset?
    @setting == :unset
  end
  
  def green?
    @setting == :green
  end
  
  def yellow?
    @setting == :yellow
  end
  
  def red?
    @setting == :red
  end
    
  def unneeded?
    @setting == :unneeded
  end
  
  def color
    @setting.to_s
  end
end