class CIAT::Processors::CompilationInterpreter
  def relevant_elements(color, path)
    element_name_hash[color]
  end
  
  def happy_path_element
    :execution
  end
  
  def input_name
    :compilation_generated
  end
  
  def output_name
    :execution
  end
  
  def error_name
    :execution_error
  end
  
  private
  def element_name_hash
    {
      CIAT::TrafficLight::GREEN => [:compilation_generated, :execution_generated],
      CIAT::TrafficLight::YELLOW => [:compilation_generated, :execution_error_generated],
      CIAT::TrafficLight::RED => [:compilation_generated, :execution_diff],
      CIAT::TrafficLight::UNSET => []
    }
  end
end