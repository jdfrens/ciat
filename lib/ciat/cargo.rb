class CIAT::Cargo
  OUTPUT_FOLDER = "temp"
  REPORT_FILENAME = "report.html"
  
  attr_reader :output_folder
  attr_reader :crates
  attr_reader :report_filename
  
  def initialize(options={})
    @output_folder = options[:output_folder] || OUTPUT_FOLDER
    if options[:files]
      folder = nil
      filenames = options[:files]
    else  
      folder = options[:folder] || "ciat"
      pattern = options[:pattern] || "*.ciat"
      path = File.join(folder, "**", pattern)
      filenames = Dir[path]
    end
    @crates = filenames.map { |filename| CIAT::Crate.new(filename, @output_folder) }
    @report_filename = options[:report_filename] || REPORT_FILENAME
  end
  
  def size
    crates.size
  end
  
  def create_output_folder
    Dir.mkdir(output_folder)
  end
end
