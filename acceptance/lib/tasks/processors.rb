def java_compiler(type)
  CIAT::Processors::Java.new('./lib/java', type + 'Compiler') do |compiler|
    compiler.kind = CIAT::Processors::Compiler.new
    compiler.description = "compiler (implemented in Java)"
  end
end

def yellow_processor
  CIAT::Processors::Java.new('./lib/java', "YellowProcessor")
end

def java_interpreter(type)
  CIAT::Processors::Java.new('./lib/java', type + 'Interpreter')
end

def compilation_interpreter
  CIAT::Processors::CompilationInterpreter.new
end

def interpreter
  CIAT::Processors::Interpreter.new
end

def parrot_executor(kind)
  CIAT::Processors::Parrot.new do |executor|
    executor.kind = kind
  end
end
