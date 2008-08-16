module CIAT
  module Feedback
    # This feedback class sends some simple messages to the screen about the
    # progress of a CIAT::Suite run.
    class StandardOutput
      LIGHT_OUTPUTS = { :green => ".", :red => "F", :yellow => "E", :unset => "-" }
      
      def post_tests(suite)
        puts "\n#{suite.size} tests executed."
      end
      
      def compilation(light)
        putc LIGHT_OUTPUTS[light]
      end
      
      def execution(light)
        putc LIGHT_OUTPUTS[light]
      end
    end
  end
end