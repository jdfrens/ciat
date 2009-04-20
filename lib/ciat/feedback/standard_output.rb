module CIAT
  module Feedback
    # This feedback class sends some simple messages to the screen about the
    # progress of a CIAT::Suite run.
    class StandardOutput
      LIGHT_OUTPUTS = { :green => ".", :red => "F", :yellow => "E", :unset => "-" }
      
      def initialize
        @error_count = 0
        @failure_count = 0
      end
      
      def error_count
        @error_count
      end
      
      def increment_error_count
        @error_count += 1
      end
      
      def failure_count
        @failure_count
      end
      
      def increment_failure_count
        @failure_count += 1
      end
      
      def pre_tests(suite)
        nil
      end
      
      def post_tests(suite)
        print "\n"
        print "#{suite.size} tests executed"
        print ", #{failure_count} failures" if failure_count > 0
        print ", #{error_count} errors" if error_count > 0
        print ".\n"
      end
      
      def processor_result(processor)
        putc LIGHT_OUTPUTS[processor.light.setting]
        case processor.light.setting
        when :red
          increment_failure_count
        when :yellow
          increment_error_count
        end
      end
    end
  end
end