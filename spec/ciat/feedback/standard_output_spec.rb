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
  
  describe "reporting on a processor" do
    before(:each) do
      @processor = mock("processor")
    end
    
    it "should report a green light" do
      @feedback.should_receive(:putc).with(".")
      
      @feedback.processor_result(@processor, CIAT::TrafficLight.new(:green))
    end
    
    it "should report a red light" do
      @feedback.should_receive(:putc).with("F")
      
      @feedback.processor_result(@processor, CIAT::TrafficLight.new(:red))
    end
    
    it "should report a yellow light" do
      @feedback.should_receive(:putc).with("E")
      
      @feedback.processor_result(@processor, CIAT::TrafficLight.new(:yellow))
    end

    it "should report an unset light" do
      @feedback.should_receive(:putc).with("-")
      
      @feedback.processor_result(@processor, CIAT::TrafficLight.new(:unset))
    end
  end
end
