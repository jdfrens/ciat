class CIAT::RakeTask
  attr_accessor :processors
  attr_accessor :files
  attr_accessor :feedback
  attr_accessor :folder
  attr_accessor :report_filename
  
  def initialize(name = :ciat)
    @name = name
    @processors = []
    yield self if block_given?
    define
  end
  
  def define
    desc "Run CIAT tests" + (@name==:test ? "" : ", #{@name}")
    task @name do
      suite = CIAT::Suite.new(
        :processors => @processors,
        :files => @files,
        :feedback => @feedback,
        :folder => @folder,
        :report_filename => @report_filename)
      suite.run
    end
  end
end