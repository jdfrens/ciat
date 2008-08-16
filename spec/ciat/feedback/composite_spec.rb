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
  
  it "should report a compilation light" do
    light = mock("traffic light")
    
    @subfeedbacks.each { |feedback| feedback.should_receive(:compilation).with(light) }

    @feedback.compilation(light)
  end

  it "should report an execution light" do
    light = mock("traffic light")
    
    @subfeedbacks.each { |feedback| feedback.should_receive(:execution).with(light) }

    @feedback.execution(light)
  end
end