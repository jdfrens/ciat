class CIAT::Test
  attr_reader :crate
  attr_reader :description
  attr_reader :traffic_lights
  attr_reader :source
  attr_reader :compilation_expected
  attr_reader :output_expected
  
  def initialize(crate, compiler, executor)
    @crate = crate
    @compiler = compiler
    @executor = executor
    @traffic_lights = Hash.new
  end
  
  def run
    split_test_file
    write_output_files
    compile
    execute
    check_output
    self
  end
  
  def traffic_light(which)
    if which == :all
      traffic_lights.values.include?(:red) ? :red : :green
    else
      traffic_lights[which]
    end
  end
  
  def split_test_file
    @description, @source, @compilation_expected, @output_expected = File.read(crate.test_file).split(/^====\s*$/).map do |s|
      s.gsub(/^\n/, '')
    end
  end
  
  def write_output_files
    write_file(crate.source, source)
    write_file(crate.compilation_expected, compilation_expected)
    write_file(crate.output_expected, output_expected)
  end

  def write_file(filename, content)
    File.open(filename, "w") do |file|
      file.write content
    end
  end

  def compile
    @compiler.compile(crate.source, crate.compilation_generated)
  end
  
  def execute
    @executor.execute(crate.compilation_generated, crate.output_generated)
  end
  
  def check_output
    @traffic_lights[:compilation] = do_diff(crate.compilation_expected, crate.compilation_generated, crate.compilation_diff)
    @traffic_lights[:output] = do_diff(crate.output_expected, crate.output_generated, crate.output_diff)
  end
  
  def do_diff(expected, generated, diff)
    system("diff '#{expected}' '#{generated}' > '#{diff}'") ? :green : :red
  end
end
