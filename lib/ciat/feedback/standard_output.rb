module CIAT
  module Feedback
    class StandardOutput
      def post_tests(suite)
        puts "#{suite.size} tests executed."
      end
    end
  end
end