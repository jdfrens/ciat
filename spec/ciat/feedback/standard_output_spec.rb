require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/standard_output'

describe CIAT::Feedback::StandardOutput do
  before(:each) do
    @feedback = CIAT::Feedback::StandardOutput.new
  end
  
  it "should report at the end" do
    suite = mock("suite")
    
    suite.should_receive(:size).and_return(88)
    @feedback.should_receive(:puts).with("88 tests executed.")
    
    @feedback.post_tests(suite)
  end

end
