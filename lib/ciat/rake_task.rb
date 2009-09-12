class CIAT::RakeTask
  attr_accessor :processors
  attr_accessor :files
  attr_accessor :feedback
  
  def initialize(name = :ciat)
    @name = name
    yield self if block_given?
    define
  end
  
  def define
    desc "Run CIAT tests" + (@name==:test ? "" : ", #{@name}")
    task @name do
      suite = CIAT::Suite.new(
        :processors => @processors,
        :files => @files,
        :feedback => @feedback)
      suite.run
    end
  end
end