class CIAT::Cargo #:nodoc:all
  OUTPUT_FOLDER = "temp"
  REPORT_FILENAME = "report.html"
  
  attr_reader :output_folder
  attr_reader :crates
  attr_reader :report_filename
  
  def initialize(options={})
    @output_folder = options[:output_folder] || OUTPUT_FOLDER
    if options[:files]
      filenames = options[:files]
    else  
      folder = options[:folder] || "ciat"
      pattern = options[:pattern] || "*.ciat"
      filenames = Dir[File.join(folder, "**", pattern)]
    end
    @crates = filenames.map { |filename| CIAT::Crate.new(filename, @output_folder) }
    @report_filename = File.join(@output_folder, options[:report_filename] || REPORT_FILENAME)
  end

end
