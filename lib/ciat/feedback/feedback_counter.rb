module CIAT
  module Feedback
    # This feedback class sends some simple messages to the screen about the
    # progress of a CIAT::Suite run.
    class FeedbackCounter
      def initialize
        @error_count = 0
        @failure_count = 0
      end
      
      def error_count
        @error_count
      end
      
      def failure_count
        @failure_count
      end
      
      def increment_error_count
        @error_count += 1
      end
      
      def increment_failure_count
        @failure_count += 1
      end
      
      def pre_tests(suite)
        nil
      end
      
      def post_tests(suite)
        nil
      end
      
      def report_subresult(subresult)
        case subresult.light.setting
        when :red
          increment_failure_count
        when :yellow
          increment_error_count
        end
      end
    end
  end
end