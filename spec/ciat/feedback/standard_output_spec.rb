require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/standard_output'

describe CIAT::Feedback::StandardOutput do
  before(:each) do
    @counter = mock("counter")
    @feedback = CIAT::Feedback::StandardOutput.new(@counter)
  end
  
  describe "the post-test report" do
    it "should report just the total number of tests" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(88)
      @counter.should_receive(:failure_count).and_return(0)
      @counter.should_receive(:error_count).and_return(0)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("88 tests executed")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)
    end
    
    it "should report the number of tests and failures" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(30)
      @counter.should_receive(:failure_count).at_least(:once).and_return(12)
      @counter.should_receive(:error_count).and_return(0)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("30 tests executed")
      @feedback.should_receive(:print).with(", 12 failures")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)      
    end

    it "should report the number of tests and errors" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(3)
      @counter.should_receive(:failure_count).and_return(0)
      @counter.should_receive(:error_count).at_least(:once).and_return(1)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("3 tests executed")
      @feedback.should_receive(:print).with(", 1 errors")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)      
    end

    it "should report the number of tests, failures, and errors" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(78)
      @counter.should_receive(:failure_count).at_least(:once).and_return(9)
      @counter.should_receive(:error_count).at_least(:once).and_return(3)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("78 tests executed")
      @feedback.should_receive(:print).with(", 9 failures")
      @feedback.should_receive(:print).with(", 3 errors")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)      
    end
  end
  
  describe "reporting on a subresult" do
    before(:each) do
      @subresult = mock("subresult")
    end
    
    it "should report a green light" do
      @subresult.should_receive(:light).at_least(:once).
        and_return(CIAT::TrafficLight::GREEN)
      @feedback.should_receive(:putc).with(".")
      
      @feedback.report_subresult(@subresult)
    end
    
    it "should report a red light" do
      @subresult.should_receive(:light).at_least(:once).
        and_return(CIAT::TrafficLight::RED)
      @feedback.should_receive(:putc).with("F")
      
      @feedback.report_subresult(@subresult)
    end
    
    it "should report a yellow light" do      
      @subresult.should_receive(:light).at_least(:once).
        and_return(CIAT::TrafficLight::YELLOW)
      @feedback.should_receive(:putc).with("E")

      @feedback.report_subresult(@subresult)
    end

    it "should report an unset light" do      
      @subresult.should_receive(:light).at_least(:once).
        and_return(CIAT::TrafficLight::UNSET)
      @feedback.should_receive(:putc).with("-")
      
      @feedback.report_subresult(@subresult)
    end

    it "should report an unneeded light" do      
      @subresult.should_receive(:light).at_least(:once).
        and_return(CIAT::TrafficLight::UNNEEDED)
      @feedback.should_receive(:putc).with(".")
      
      @feedback.report_subresult(@subresult)
    end
  end
  
end
