class CIAT::TrafficLight
  attr_reader :setting
  
  def initialize(setting = :unset) #:nodoc:
    @setting = setting
  end
  
  def unset?
    @setting == :unset
  end
  
  def green?
    @setting == :green
  end
  
  def green! #:nodoc:
    @setting = :green unless yellow?
  end
  
  def yellow?
    @setting == :yellow
  end
  
  def yellow! #:nodoc:
    @setting = :yellow
  end
  
  def red?
    @setting == :red
  end
  
  def red! #:nodoc:
    @setting = :red unless yellow?
  end
  
  def color
    @setting.to_s
  end
end