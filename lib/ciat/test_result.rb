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
    @subresults.map { |subresult| subresult.processor }
  end
  
  def filename
    @test.filename(:ciat)
  end
  
  def element(*args)
    @test.element(*args)
  end
end