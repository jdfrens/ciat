require 'ciat/erb_helpers'
require 'ciat/feedback/html_feedback_builder'
require 'ciat/io'

module CIAT::Feedback
  class HtmlFeedback
    include CIAT::ERBHelpers
    include CIAT::IO
    
    DATA_FOLDER = File.join(File.dirname(__FILE__), "..", "..", "data")
    
    attr_reader :report_title
    attr_reader :report_filename
    
    def initialize(counter, options)
      @counter = counter
      builder = CIAT::Feedback::HtmlFeedbackBuilder.new(options)
      @report_title = builder.build_report_title
      @report_filename = builder.build_report_filename
    end

    def pre_tests(suite)
      FileUtils.mkdir_p(suite.output_folder)
      FileUtils.cp(File.join(DATA_FOLDER, "ciat.css"), suite.output_folder)
      FileUtils.cp(File.join(DATA_FOLDER, "prototype.js"), suite.output_folder)
    end
  
    def report_subresult(processor)
      nil
    end
  
    def post_tests(suite)
      write_file(
        report_filename, 
        generate_html(suite)
        )
    end

    def generate_html(suite) #:nodoc:
      processors = suite.processors
      results = suite.results
      size = suite.size
      counter = @counter
      build_erb.result(binding)
    end
    
    def build_erb
      erb = ERB.new(template)
      erb.filename = "report.html.erb"
      erb
    end

    def template #:nodoc:
      File.read(File.join(
        File.dirname(__FILE__), "..", "..", "templates", "report.html.erb"
        ))
    end
  end
end
