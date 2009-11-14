module CIAT::Processors
  class Compiler
    def relevant_elements(color, path)
      element_name_hash[path][color]
    end
  
    def happy_path_element
      :compilation
    end

    def input_name
      :source
    end
  
    def output_name
      :compilation
    end
  
    def error_name
      :compilation_error
    end

    private
    def element_name_hash
      {
        :happy => {
          CIAT::TrafficLight::GREEN => [:source, :compilation_generated],
          CIAT::TrafficLight::YELLOW => [:source, :compilation_generated, :compilation_error_generated],
          CIAT::TrafficLight::RED => [:source, :compilation_diff],
          CIAT::TrafficLight::UNSET => []
        },
        :sad => {
          CIAT::TrafficLight::GREEN => [:source, :compilation_generated, :compilation_error_generated],
          CIAT::TrafficLight::YELLOW => [:source, :compilation_generated, :compilation_error_generated],
          CIAT::TrafficLight::RED => [:source, :compilation_diff],
          CIAT::TrafficLight::UNSET => []
        }
      }
    end
  end
end
