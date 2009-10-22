require 'ciat/io'

class CIAT::Feedback::HtmlFeedbackBuilder
  include CIAT::IO
  
  attr_reader :options
  
  def initialize(options)
    @options = options
  end
  
  def build_output_folder
    options[:output_folder] || OUTPUT_FOLDER
  end
  
  def build_report_filename
    File.join(build_output_folder, options[:report_filename] || REPORT_FILENAME)
  end
  
  def build_report_title
    if options[:report_title]
      "CIAT Report: " + options[:report_title]
    else
      "CIAT Report"
    end
  end

end