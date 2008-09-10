require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/composite'

describe CIAT::Feedback::Composite do
  before(:each) do
    @subfeedbacks = [mock("feedback 1"), mock("feedback 2"), mock("feedback 3")]
    @feedback = CIAT::Feedback::Composite.new(*@subfeedbacks)
  end
  
  it "should report at the end" do
    suite = mock("suite")
    
    @subfeedbacks.each { |feedback| feedback.should_receive(:post_tests).with(suite) }
    
    @feedback.post_tests(suite)
  end
  
  it "should report a processor light" do
    processor, light = mock("processor"), mock("traffic light")
    
    @subfeedbacks.each do |feedback|
      feedback.should_receive(:processor_result).with(processor, light)
    end

    @feedback.processor_result(processor, light)
  end
end