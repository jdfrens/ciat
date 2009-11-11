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
    
    def report_subresult(subresult)
      @failure ||= subresult_failure?(subresult, subresult.light)
    end
    
    private
    def subresult_failure?(subresult, light)
      light.yellow? || light.red?
    end
    
    def failure?
      @failure
    end
  end
end