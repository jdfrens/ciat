require 'ciat/erb_helpers'

module CIAT::Feedback
  class HtmlFeedback
    include CIAT::ERBHelpers

    def pre_tests(suite)
      suite.cargo.copy_suite_data      
    end
  
    def processor_result(processor)
      nil
    end
  
    def post_tests(suite)
      suite.cargo.write_file(
        suite.cargo.report_filename, 
        generate_html(suite))
    end

    def generate_html(suite) #:nodoc:
      processors = suite.processors
      results = suite.results
      report_title = suite.report_title
      ERB.new(template).result(binding)
    end

    def template #:nodoc:
      File.read(File.join(
        File.dirname(__FILE__), "..", "..", "templates", "report.html.erb"
        ))
    end
  end
end
