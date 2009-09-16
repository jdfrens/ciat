require 'ciat/feedback/feedback_counter'

#
# Compilers & Executors
#
def copy_compiler
  CIAT::Processors::Copy.new(:source, :compilation)
end

def java_compiler(type)
  CIAT::Compilers::Java.new('./java', type + 'Compiler')
end

def java_interpreter(type)
  CIAT::Executors::Java.new('./java', type + 'Interpreter')
end

def copy_executor
  CIAT::Processors::Copy.new(:compilation_generated, :execution)
end

def compilation_interpreter
  CIAT::Processors::CompilationInterpreter.new
end

def interpreter
  CIAT::Processors::Interpreter.new
end

def parrot_executor(kind)
  CIAT::Executors::Parrot.new(:processor_kind => kind)
end

#
# Output file checking
#
def check_output_files
  puts "Checking output files."
  Dir["**/*.html"].each do |file|
    puts "tidy -mq #{file}"
    system "tidy -mq #{file}"
  end
  unless system("diff -r temp_expected/ temp/ > acceptance.diff")
    raise("**** diff failed!")
  end
end

#
# Feedback
#
def feedback(size, expected_lights)
  counter = CIAT::Feedback::FeedbackCounter.new
  CIAT::Feedback::Composite.new(counter,
    CIAT::Feedback::StandardOutput.new(counter),
    CIAT::Feedback::HtmlFeedback.new(counter),
    FeedbackTester.new(size, expected_lights)
    )
end

def deliberate_failure
  ooops = false
  begin
    yield
    ooops = true
  rescue RuntimeError => e
  end
  fail "Should have failed at the end" if ooops  
end
