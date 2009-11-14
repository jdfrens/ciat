class CIAT::Processors::Interpreter
  def relevant_elements(color, path)
    element_name_hash[path][color]
  end
  
  def happy_path_element
    :execution
  end

  def input_name
    :source
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
      :happy => {
        CIAT::TrafficLight::GREEN => [:source, :command_line, :execution_generated],
        CIAT::TrafficLight::YELLOW => [:source, :command_line, :execution_generated, :execution_error_generated],
        CIAT::TrafficLight::RED => [:source, :command_line, :execution_diff],
        CIAT::TrafficLight::UNSET => []
      },
      :sad => {
        CIAT::TrafficLight::GREEN => [:source, :command_line, :execution_error_generated],
       CIAT::TrafficLight::YELLOW => [:source, :command_line, :execution_generated, :execution_error_generated],
        CIAT::TrafficLight::RED => [:source, :command_line, :execution_error_diff],
        CIAT::TrafficLight::UNSET => []
      }
    }
  end
end