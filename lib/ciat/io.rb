module CIAT::IO
  
  OUTPUT_FOLDER = "temp"
  REPORT_FILENAME = "report.html"
  
  def write_file(filename, content)
    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename, "w") do |file|
      file.write content
    end
  end
  
  def read_file(filename)
    File.read(filename)
  end
  
end