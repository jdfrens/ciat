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
  
  def build_ciat_files
    if options[:files]
      make_ciat_files(options[:files])
    else  
      folder = options[:folder] || "ciat"
      pattern = options[:pattern] || "*.ciat"
      make_ciat_files(Dir[File.join(folder, "**", pattern)])
    end
  end
  
  def make_ciat_files(filenames)
    if filenames.empty?
      raise IOError.new("no test files specified")
    end
    filenames.map do |filename|
      CIAT::CiatFile.new(filename, build_output_folder)
    end
  end
  
  def build_feedback
    CIAT::Feedback::Composite.new(
        options[:feedback] || default_feedback,
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