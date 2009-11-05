require 'rake'
require 'ciat/differs/html_differ'

module CIAT::Processors
  # TODO: rename this!
  class BasicProcessing
    include CIAT::Differs::HtmlDiffer
    
    # TODO: don't like this...
    attr_reader :processor
    
    def initialize(ciat_file, processor)
      @ciat_file = ciat_file
      @processor = processor
    end
    
    def describe
      @processor.describe
    end
    
    # Executes the program, and diffs the output.
    def process(test)
      if execute(test)
        if diff(test)
          CIAT::TrafficLight::GREEN
        else
          CIAT::TrafficLight::RED
        end
      else
        CIAT::TrafficLight::YELLOW
      end
    end

    def execute(test)
      RakeFileUtils.verbose(false) do
        sh(command_line(test)) do |ok, result|
          return happy_path?(test) == ok
        end
      end
    end
    
    def happy_path?(test)
      test.element?(@processor.kind.happy_path_element)
    end
    
    def path_kind(test)
      happy_path?(test) ? :happy : :sad
    end
    
    def command_line(test)
      "#{@processor.executable} '#{input_file(test)}' #{command_line_args(test)} > '#{output_file(test)}' 2> '#{error_file(test)}'"
    end
    
    def command_line_args(test) #:nodoc:
      if test.element?(:command_line)
        test.element(:command_line).content.strip
      else
        ''
      end
    end
    
    def input_file(test)
      test.element(@processor.kind.input_name).as_file
    end

    def output_file(test)
      test.element(@processor.kind.output_name, :generated).as_file
    end

    def error_file(test)
      test.element(@processor.kind.error_name, :generated).as_file
    end

    # Compares the expected and generated executions.
    def diff(test)
      element_name = happy_path?(test) ? @processor.kind.output_name : @processor.kind.error_name
      html_diff(
        test.element(element_name).as_file,
        test.element(element_name, :generated).as_file, 
        test.element(element_name, :diff).as_file)
    end
  end
end