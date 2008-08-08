module CIAT
  module Feedback
    # This feedback class sends some simple messages to the screen about the
    # progress of a CIAT::Suite run.
    class StandardOutput
      def post_tests(suite)
        puts "#{suite.size} tests executed."
      end
    end
  end
end