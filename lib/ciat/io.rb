module CIAT::IO
  
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