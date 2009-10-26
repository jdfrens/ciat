class CIAT::TestResult
  attr_reader :subresults
  
  def initialize(test, subresults)
    @test = test
    @subresults = subresults
  end
  
  def grouping
    @test.grouping
  end
  
  def processors
    @test.processors
  end
  
  def filename
    @test.filename
  end
  
  def element(*args)
    @test.element(*args)
  end
end