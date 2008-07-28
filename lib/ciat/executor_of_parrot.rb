module CIAT
  # Executor class for Parrot programs.  This will execute PIR or PASM code
  # using the +parrot+ executable.
  class ExecutorOfParrot
    def run(generated_pir, generated_output)
      system("parrot '#{generated_pir}' &> '#{generated_output}'")
    end
  end
end
