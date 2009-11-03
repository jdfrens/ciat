class CIAT::Processors::Compiler
  def element_name_hash
    {
      :green => [:source, :compilation_generated],
      :yellow => [:source, :compilation_error_generated],
      :red => [:source, :compilation_diff],
      :unset => []
    }
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
end