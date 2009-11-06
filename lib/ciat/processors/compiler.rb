module CIAT::Processors
  class Compiler
    def relevant_elements(color, path)
      element_name_hash[color]
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
        :green => [:source, :compilation_generated],
        :yellow => [:source, :compilation_error_generated],
        :red => [:source, :compilation_diff],
        :unset => []
      }
    end
  end
end
