# A feedback mechanism for failing a task
module CIAT::Feedback
  class ReturnStatus
    def pre_tests(suite)
      @failure = false
    end
    
    def post_tests(suite)
      if failure?
        fail "CIAT tests unsuccessful"
      end
    end
    
    def processor_result(processor)
      @failure ||= processor.light.yellow? || processor.light.red?
    end
    
    private
    def failure?
      @failure
    end
  end
end