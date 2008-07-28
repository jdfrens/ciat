module CIAT
  # Executor class for Parrot programs.  This will execute PIR or PASM code
  # using the +parrot+ executable.
  class ExecutorOfParrot
    # Runs +target_filename+ through +parrot+, and both standard out and standard err are redirected to
    # +output_filename+.
    def run(target_filename, output_filename)
      system("parrot '#{target_filename}' &> '#{output_filename}'")
    end
  end
end
