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
    options[:output_folder] || OUTPUT_FOLDER
  end
  
  def build_test_files
    if options[:files]
      filenames = options[:files]
    else  
      folder = options[:folder] || "ciat"
      pattern = options[:pattern] || "*.ciat"
      filenames = Dir[File.join(folder, "**", pattern)]
    end
    filenames.map do |filename|
      CIAT::TestFile.new(filename, build_output_folder)
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