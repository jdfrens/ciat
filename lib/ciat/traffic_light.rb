class CIAT::TrafficLight
  def initialize(setting = :unset)
    @setting = setting
  end
  
  def green?
    @setting == :green
  end
  
  def green!
    @setting = :green unless yellow?
  end
  
  def yellow?
    @setting == :yellow
  end
  
  def yellow!
    @setting = :yellow
  end
  
  def red?
    @setting == :red
  end
  
  def red!
    @setting = :red unless yellow?
  end
end