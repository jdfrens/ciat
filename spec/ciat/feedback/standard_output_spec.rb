require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/standard_output'

describe CIAT::Feedback::StandardOutput do
  before(:each) do
    @feedback = CIAT::Feedback::StandardOutput.new
  end
  
  it "should report at the end" do
    suite = mock("suite")
    
    suite.should_receive(:size).and_return(88)
    @feedback.should_receive(:puts).with("\n88 tests executed.")
    
    @feedback.post_tests(suite)
  end
  
  describe "reporting on a compilation" do
    it "should report a green light" do
      @feedback.should_receive(:putc).with(".")
      
      @feedback.compilation(:green)
    end
    
    it "should report a red light" do
      @feedback.should_receive(:putc).with("F")
      
      @feedback.compilation(:red)
    end
    
    it "should report a yellow light" do
      @feedback.should_receive(:putc).with("E")
      
      @feedback.compilation(:yellow)
    end
  end

  describe "reporting on an execution" do
    it "should report a green light" do
      @feedback.should_receive(:putc).with(".")
      
      @feedback.execution(:green)
    end
    
    it "should report a red light" do
      @feedback.should_receive(:putc).with("F")
      
      @feedback.execution(:red)
    end
    
    it "should report a yellow light" do
      @feedback.should_receive(:putc).with("E")
      
      @feedback.execution(:yellow)
    end
  end
end
