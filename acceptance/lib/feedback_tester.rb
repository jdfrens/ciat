class FeedbackTester
  def initialize(size, expected_lights)
    @size = size
    @expected_lights = expected_lights
    @lights = []
  end
  
  def report_subresult(subresult)
    @lights << subresult.light.color.to_sym
  end
  
  def pre_tests(suite)
    nil
  end
  
  def post_tests(suite)
    unless @expected_lights == @lights
      raise "Wrong lights: [#{@expected_lights.join(',')}] expected, got [#{@lights.join(',')}]"
    end
    unless suite.size == @size
      raise "Wrong number of tests: #{@size} expected, got #{suite.size}"
    end
  end
end
