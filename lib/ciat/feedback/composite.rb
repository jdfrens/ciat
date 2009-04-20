# A feedback mechanism for compositing other feedbacks.
module CIAT::Feedback
  class Composite
    # Pass in instances of the feedbacks as arguments to the constructor.
    def initialize(*feedbacks)
      @feedbacks = feedbacks
    end
  
    def pre_tests(suite)
      @feedbacks.each { |feedback| feedback.pre_tests(suite) }
    end
    def post_tests(suite)
      @feedbacks.each { |feedback| feedback.post_tests(suite) }
    end
  
    def processor_result(processor)
      @feedbacks.each { |feedback| feedback.processor_result(processor) }
    end
  end
end