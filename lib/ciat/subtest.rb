require 'rake'
require 'ciat/differs/html_differ'

class CIAT::Subtest
  include CIAT::Differs::HtmlDiffer
  
  attr_reader :processor
  
  def initialize(ciat_file, processor)
    @ciat_file = ciat_file
    @processor = processor
  end
  
  def describe
    @processor.describe
  end
  
  # Executes the program, and diffs the output.
  def process
    if execute
      if diff
        CIAT::TrafficLight::GREEN
      else
        CIAT::TrafficLight::RED
      end
    else
      CIAT::TrafficLight::YELLOW
    end
  end

  def execute
    RakeFileUtils.verbose(false) do
      sh(command_line) do |ok, result|
        return happy_path? == ok
      end
    end
  end
  
  def happy_path?
    @ciat_file.element?(@processor.kind.happy_path_element)
  end
  
  def sad_path?
    not happy_path?
  end
  
  def path_kind
    happy_path? ? :happy : :sad
  end
  
  def command_line
    "#{@processor.executable} '#{input_file}' #{command_line_args} > '#{output_file}' 2> '#{error_file}'"
  end
  
  def command_line_args
    if @ciat_file.element?(:command_line)
      @ciat_file.element(:command_line).content.strip
    else
      ''
    end
  end
  
  def input_file
    @ciat_file.element(@processor.kind.input_name).as_file
  end

  def output_file
    @ciat_file.element(@processor.kind.output_name, :generated).as_file
  end

  def error_file
    @ciat_file.element(@processor.kind.error_name, :generated).as_file
  end

  # Compares the expected and generated executions.
  def diff
    element_name = happy_path? ? @processor.kind.output_name : @processor.kind.error_name
    html_diff(
      @ciat_file.element(element_name).as_file,
      @ciat_file.element(element_name, :generated).as_file, 
      @ciat_file.element(element_name, :diff).as_file)
  end
end