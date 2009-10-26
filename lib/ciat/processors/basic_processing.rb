require 'ciat/differs/html_differ'

module CIAT::Processors
  module BasicProcessing
    include CIAT::Differs::HtmlDiffer
    
    # Executes the program, and diffs the output.
    def process(test)
      # TODO: verify required elements
      # TODO: handle optional element
      if execute(test)
        if diff(test)
          CIAT::TrafficLight.new(:green)
        else
          CIAT::TrafficLight.new(:red)
        end
      else
        CIAT::TrafficLight.new(:yellow)
      end
    end
    
    def command_line_args(test) #:nodoc:
      test.element?(:command_line) ? test.element(:command_line).content.strip : ''
    end
    
    # Compares the expected and generated executions.
    def diff(test)
      html_diff(
        test.element(kind.output_name).as_file,
        test.element(kind.output_name, :generated).as_file, 
        test.element(kind.output_name, :diff).as_file)
    end
    
    def input_file(test)
      test.element(kind.input_name).as_file
    end

    def output_file(test)
      test.element(kind.output_name, :generated).as_file
    end

    def error_file(test)
      test.element(kind.output_name, :error).as_file
    end
  end
end