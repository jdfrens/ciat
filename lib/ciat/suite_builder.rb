require 'ciat/io'

class CIAT::SuiteBuilder
  include CIAT::IO
  
  attr_reader :options
  
  def initialize(options)
    @options = options
  end
  
  def build_processors
    options[:processors]
  end
  
  def build_output_folder
    @output_folder ||= options[:output_folder] || OUTPUT_FOLDER
  end
  
  def build_crates
    if options[:files]
      filenames = options[:files]
    else  
      folder = options[:folder] || "ciat"
      pattern = options[:pattern] || "*.ciat"
      filenames = Dir[File.join(folder, "**", pattern)]
    end
    filenames.map { |filename| CIAT::Crate.new(filename, build_output_folder) }
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
  
  def build_feedback
    CIAT::Feedback::Composite.new(
        options[:feedback] || default_feedback(options),
        CIAT::Feedback::ReturnStatus.new
      )
  end

  def default_feedback
    counter = CIAT::Feedback::FeedbackCounter.new
    CIAT::Feedback::Composite.new(counter,
      CIAT::Feedback::StandardOutput.new(counter),
      CIAT::Feedback::HtmlFeedback.new(counter, options)
      )
  end

end