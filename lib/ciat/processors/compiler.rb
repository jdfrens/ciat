class CIAT::Processors::Compiler
  def element_name_hash
    {
      :green => [:source, :compilation_generated],
      :yellow => [:source, :compilation_error],
      :red => [:source, :compilation_diff],
      :unset => []
    }
  end

  def input_name
    :source
  end
  
  def output_name
    :compilation
  end
end