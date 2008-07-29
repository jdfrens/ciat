module CIAT
  # Executor class for Parrot programs.  This will execute PIR or PASM code
  # using the +parrot+ executable.
  class ExecutorOfParrot
    def run(compilation_generated, output_generated)
      system("parrot '#{compilation_generated}' &> '#{output_generated}'")
    end
  end
end
