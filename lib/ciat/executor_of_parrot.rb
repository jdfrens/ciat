module CIAT
  class ExecutorOfParrot  
    def run(generated_pir, generated_output)
      system("parrot '#{generated_pir}' &> '#{generated_output}'")
    end
  end
end
