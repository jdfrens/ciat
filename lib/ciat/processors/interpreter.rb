class CIAT::Processors::Interpreter
  def element_name_hash
    {
      :green => [:source, :command_line, :execution_generated],
      :yellow => [:source, :command_line, :execution_error_generated],
      :red => [:source, :command_line, :execution_diff],
      :unset => []
    }
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
end