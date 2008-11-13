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
    @crates = filenames.map { |filename| CIAT::Crate.new(filename, self) }
    @report_filename = File.join(@output_folder, options[:report_filename] || REPORT_FILENAME)
  end
  
  def size
    crates.size
  end
  
  def copy_suite_data
    FileUtils.mkdir_p(output_folder)
    FileUtils.cp(File.join(File.dirname(__FILE__), "..", "data", "ciat.css"), output_folder)
    FileUtils.cp(File.join(File.dirname(__FILE__), "..", "data", "prototype.js"), output_folder)
  end
  
  # TODO: get rid of this in favor of the class method
  def write_file(filename, content)
    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename, "w") do |file|
      file.write content
    end
  end
  
  # TODO: get rid of this in favor of the class method
  def read_file(filename)
    File.read(filename)
  end

  def self.write_file(filename, content)
    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename, "w") do |file|
      file.write content
    end
  end
  
  def self.read_file(filename)
    File.read(filename)
  end
end
