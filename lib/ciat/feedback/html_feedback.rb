class HtmlFeedback
  include CIAT::ERBHelpers

  attr_reader :processors
  
  def initialize(cargo, processors)
    @cargo = cargo
    @processors = processors
  end
  
  def pre_tests(suite)
    suite.cargo.copy_suite_data      
  end
  
  def processor_result(processor)
    nil
  end
  
  def post_tests(suite)
    @cargo.write_file(@cargo.report_filename, generate_html(suite.results))
  end

  def generate_html(results) #:nodoc:
    ERB.new(template).result(binding)
  end

  def template #:nodoc:
    File.read(File.join(File.dirname(__FILE__), "..", "..", "templates", "report.html.erb"))
  end
end

