module CIAT
  module Feedback
    # This feedback class sends some simple messages to the screen about the
    # progress of a CIAT::Suite run.
    class StandardOutput
      LIGHT_OUTPUTS = {
        CIAT::TrafficLight::GREEN => ".", 
        CIAT::TrafficLight::RED => "F", 
        CIAT::TrafficLight::YELLOW => "E", 
        CIAT::TrafficLight::UNSET => "-",
        CIAT::TrafficLight::UNNEEDED => "." }
      
      def initialize(counter)
        @counter = counter
      end
            
      def pre_tests(suite)
        nil
      end
      
      def post_tests(suite)
        print "\n"
        print "#{suite.size} tests executed"
        print ", #{@counter.failure_count} failures" if @counter.failure_count > 0
        print ", #{@counter.error_count} errors" if @counter.error_count > 0
        print ".\n"
      end
      
      def report_subresult(processor)
        putc LIGHT_OUTPUTS[processor.light]
      end
    end
  end
end