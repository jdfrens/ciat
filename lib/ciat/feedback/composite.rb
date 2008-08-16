class CIAT::Feedback::Composite
  def initialize(*feedbacks)
    @feedbacks = feedbacks
  end
  
  def post_tests(suite)
    @feedbacks.each { |feedback| feedback.post_tests(suite) }
  end
  
  def compilation(light)
    @feedbacks.each { |feedback| feedback.compilation(light) }
  end
  
  def execution(light)
    @feedbacks.each { |feedback| feedback.execution(light) }
  end
end