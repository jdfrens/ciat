module CIAT
  # Executor class for Parrot programs.  This will execute PIR or PASM code
  # using the +parrot+ executable.
  class ExecutorOfParrot
    def run(generated_compilation, generated_output)
      system("parrot '#{generated_compilation}' &> '#{generated_output}'")
    end
  end
end
