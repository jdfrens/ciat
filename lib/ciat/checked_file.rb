module CIAT
  # Generates filenames for the three files needed to check a result: the
  # expected, the generated, and the diff.
  class CheckedFile
    # Creates a bunch of CIAT::CheckedFile objects based on one crate and
    # multiple modifiers.
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
end