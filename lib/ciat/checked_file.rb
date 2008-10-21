class CIAT::CheckedFile
  def self.create(crate, *modifiers)
    modifiers.map { |modifier| CIAT::CheckedFile.new(crate, modifier) }
  end
  
  def initialize(crate, modifier)
    @crate = crate
    @modifier = modifier
  end
  
  def expected
    @crate.filename(@modifier)    
  end
  
  def generated
    @crate.filename(@modifier, :generated)
  end
  
  def diff
    @crate.filename(@modifier, :diff)
  end
end