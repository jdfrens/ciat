module CIAT
  module Feedback
    # This feedback class sends some simple messages to the screen about the
    # progress of a CIAT::Suite run.
    class FeedbackCounter
      def initialize
        @counts = {
          CIAT::TrafficLight::RED => 0,
          CIAT::TrafficLight::YELLOW => 0,
          CIAT::TrafficLight::GREEN => 0,
          CIAT::TrafficLight::UNSET => 0,
          CIAT::TrafficLight::UNNEEDED => 0
        }
      end
      
      def error_count
        @counts[CIAT::TrafficLight::YELLOW]
      end
      
      def failure_count
        @counts[CIAT::TrafficLight::RED]
      end
            
      def pre_tests(suite)
        nil
      end
      
      def post_tests(suite)
        nil
      end
      
      def report_subresult(subresult)
        @counts[subresult.light] = @counts[subresult.light] + 1
      end
    end
  end
end