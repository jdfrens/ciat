class CIAT::Test
  attr_reader :crate
  attr_reader :description
  attr_reader :traffic_lights
  attr_reader :source
  attr_reader :compilation_expected
  attr_reader :output_expected
  
  def initialize(crate, compiler, executor, options={})
    @crate = crate
    @compiler = compiler
    @executor = executor
    @traffic_lights = options[:traffic_lights] || 
      { :compilation => CIAT::TrafficLight.new, :output => CIAT::TrafficLight.new }
  end
  
  def run
    split_test_file
    write_output_files
    compile
    execute
    check_output
    self
  end
  
  def split_test_file
    @description, @source, @compilation_expected, @output_expected = File.read(crate.test_file).split(/^====\s*$/).map do |s|
      s.gsub(/^\n/, '')
    end
  end
  
  def write_output_files
    crate.write_file(crate.source, source)
    crate.write_file(crate.compilation_expected, compilation_expected)
    unless output_expected =~ /^\s*NONE\s*$/
      crate.write_file(crate.output_expected, output_expected)
    end
  end

  def compile
    unless @compiler.compile(crate.source, crate.compilation_generated)
      traffic_lights[:compilation].yellow!
    end
  end
  
  def execute
    unless traffic_lights[:compilation].yellow?
      @executor.execute(crate.compilation_generated, crate.output_generated)
    end
  end
  
  def check_output
    do_diff(:compilation, crate.compilation_expected, crate.compilation_generated, crate.compilation_diff)
    unless traffic_lights[:compilation].yellow?
      do_diff(:output, crate.output_expected, crate.output_generated, crate.output_diff)
    end
  end
  
  def do_diff(which, expected, generated, diff)
    if system("diff '#{expected}' '#{generated}' > '#{diff}'")
      @traffic_lights[which].green!
    else
      @traffic_lights[which].red!
    end
  end
end
