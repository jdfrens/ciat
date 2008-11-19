#
# Compilers & Executors
#
def copy_compiler
  CIAT::Processors::Copy.new(:source, :compilation)
end

def java_compiler(type)
  CIAT::Compilers::Java.new('./java', type + 'Compiler')
end

def copy_executor
  CIAT::Processors::Copy.new(:compilation_generated, :execution)
end

def parrot_executor
  CIAT::Executors::Parrot.new
end

#
# Output file checking
#
def check_output_files
  puts "Checking output files."
  Dir["**/*.html"].each do |file|
    system "tidy -mq #{file} 2> /dev/null"
  end
  unless system("diff -r temp_expected/ temp/")
    raise("**** diff failed!")
  end
end

#
# Feedback
#
def feedback(size, expected_lights)
  CIAT::Feedback::Composite.new(
    CIAT::Feedback::StandardOutput.new,
    FeedbackTester.new(size, expected_lights)
    )
end
