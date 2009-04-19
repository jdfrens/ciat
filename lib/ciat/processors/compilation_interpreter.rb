class CIAT::Processors::CompilationInterpreter
  def element_name_hash
    {
      :green => [:compilation_generated, :execution_generated],
      :yellow => [:compilation_generated, :execution_error],
      :red => [:compilation_generated, :execution_diff]
    }
  end
  
  def input_name
    :compilation_generated
  end
  
  def output_name
    :execution
  end
end