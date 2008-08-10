class CIAT::Test
  attr_reader :crate
  attr_reader :description
  attr_reader :source
  attr_reader :compilation_expected
  attr_reader :output_expected
  attr_reader :compilation_light
  attr_reader :execution_light
  
  def initialize(crate, compiler, executor, options={}) #:nodoc:
    @crate = crate
    @compiler = compiler
    @executor = executor
    @compilation_light = options[:compilation_light] || CIAT::TrafficLight.new
    @execution_light = options[:execution_light] || CIAT::TrafficLight.new
  end
  
  def run
    split_test_file
    write_output_files
    compile
    check(:compilation, @compilation_light)
    if @compilation_light.green?
      execute
      check(:output, @execution_light)
    end
    self
  end
  
  def split_test_file #:nodoc:
    @description, @source, @compilation_expected, @output_expected = File.read(crate.test_file).split(/^====\s*$/).map do |s|
      s.gsub(/^\n/, '')
    end
  end
  
  def write_output_files #:nodoc:
    crate.write_file(crate.source, source)
    crate.write_file(crate.compilation_expected, compilation_expected)
    unless output_expected =~ /^\s*NONE\s*$/
      crate.write_file(crate.output_expected, output_expected)
    end
  end

  def compile #:nodoc:
    unless @compiler.compile(crate.source, crate.compilation_generated)
      @compilation_light.yellow!
    end
  end
  
  def execute #:nodoc:
    unless @executor.execute(crate.compilation_generated, crate.output_generated)
      @execution_light.yellow!
    end
  end
  
  def check(which, traffic_light) #:nodoc:
    expected = crate.output_filename(which, :expected)
    generated = crate.output_filename(which, :generated)
    diff = crate.output_filename(which, :diff)
    if system("diff '#{expected}' '#{generated}' > '#{diff}'")
      traffic_light.green!
    else
      traffic_light.red!
    end
  end
end
