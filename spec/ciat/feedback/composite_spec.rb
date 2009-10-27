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
  
  it "should report a light" do
    subresult = mock("subresult")
    
    @subfeedbacks.each do |feedback|
      feedback.should_receive(:report_subresult).with(subresult)
    end

    @feedback.report_subresult(subresult)
  end
end