# A feedback mechanism for compositing other feedbacks.
class CIAT::Feedback::Composite
  # Pass in instances of the feedbacks as arguments to the constructor.
  def initialize(*feedbacks)
    @feedbacks = feedbacks
  end
  
  def post_tests(suite)
    @feedbacks.each { |feedback| feedback.post_tests(suite) }
  end
  
  def processor_result(processor, light)
    @feedbacks.each { |feedback| feedback.processor_result(processor, light) }
  end
end