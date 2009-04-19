class CIAT::Processors::Interpreter
  def element_name_hash
    {
      :green => [:source, :command_line, :execution_generated],
      :yellow => [:source, :command_line, :execution_error],
      :red => [:source, :command_line, :execution_diff]
    }
  end
  
  def input_name
    :source
  end
  
  def output_name
    :execution
  end
end