module CIAT::Processors
  module BasicProcessing
    def execute(test)
      system "#{executable} '#{input_file(test)}' #{command_line_args(test)} > '#{output_file(test)}' 2> '#{error_file(test)}'"
    end
    
    def command_line_args(test) #:nodoc:
      test.element?(:command_line) ? test.element(:command_line).content.strip : ''
    end
    
    def relevant_elements(test)
      relevant_element_names.
        select { |name| test.element?(name) }.
        map { |name| test.element(name) }
    end
  
    def relevant_element_names
      processor_kind.element_name_hash[light.setting]
    end
    
    def input_file(test)
      test.element(processor_kind.input_name).as_file
    end

    def output_file(test)
      test.element(processor_kind.output_name, :generated).as_file
    end

    def error_file(test)
      test.element(processor_kind.output_name, :error).as_file
    end
  end
end