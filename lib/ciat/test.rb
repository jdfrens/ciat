class CIAT::Test
  attr_reader :crate
  attr_reader :elements
  attr_reader :compilation_light
  attr_reader :execution_light

  def initialize(crate, options={}) #:nodoc:
    @crate = crate
    @compiler, @executor = options[:processors]
    @compilation_light = options[:compilation_light] || CIAT::TrafficLight.new
    @execution_light = options[:execution_light] || CIAT::TrafficLight.new
    @feedback = options[:feedback]
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
    report_lights
    self
  end
  
  def split_test_file #:nodoc:
    elements = File.read(crate.test_file).split(/^====.*$/).map do |s|
      s.gsub(/^\n/, '')
    end
    @elements = {}
    [:description, :source, :compilation_expected, :output_expected].zip(elements) do |name, element|
      @elements[name] = element
    end
    @elements
  end
  
  def compilation_diff
    crate.read_file(crate.compilation_diff)
  end
  
  def output_diff
    crate.read_file(crate.output_diff)
  end
  
  def write_output_files #:nodoc:
    crate.write_file(crate.source, elements[:source])
    crate.write_file(crate.compilation_expected, elements[:compilation_expected])
    unless elements[:output_expected] =~ /^\s*NONE\s*$/
      crate.write_file(crate.output_expected, elements[:output_expected])
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
    if diff(expected, generated, diff)
      traffic_light.green!
    else
      traffic_light.red!
    end
  end
  
  def diff(expected, generated, diff)
    system("diff #{diff_options} '#{expected}' '#{generated}' > '#{diff}'")
  end
  
  def diff_options
    "--old-group-format='<tr><td class=\"red\"><pre>%<</pre></td><td></td></tr>' " + 
    "--new-group-format='<tr><td></td><td class=\"red\"><pre>%></pre><td></tr>' " +
    "--changed-group-format='<tr class=\"yellow\"><td><pre>%<</pre></td><td><pre>%></pre></td></tr>' " +
    "--unchanged-group-format='<tr class=\"green\"><td><pre>%=</pre></td><td><pre>%=</pre></td></tr>'"
  end
  
  def report_lights
    @feedback.compilation(compilation_light.setting)
    @feedback.execution(execution_light.setting)
  end
end
