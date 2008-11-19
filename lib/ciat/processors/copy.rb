module CIAT
  module Processors
    # A simple processor that just simply copies the code from one file to the other
    # using the Unix +cp+ command.
    class Copy
      attr_reader :light
      
      def initialize(original, copy)
        @original = original
        @copy = copy
        @light = CIAT::TrafficLight.new
      end
      
      def describe(what=:self)
        case what
        when :self
          "copy processor"
        when @original
          "original element"
        when @copy
          "copied element"
        else
          raise "cannot describe #{what.inspect} #{@original.inspect}"
        end
      end
      
      def process(crate)
        if system( "cp '#{crate.element(@original).as_file}' '#{crate.element(@copy).as_file}'")
          light.green!
        else
          light.red!
        end
      end
      
      def elements(crate)
        [@original, @copy].map { |e| crate.element(e) }
      end
    end
  end
end
