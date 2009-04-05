require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/standard_output'

describe CIAT::Feedback::StandardOutput do
  before(:each) do
    @feedback = CIAT::Feedback::StandardOutput.new
  end
  
  describe "the post-test report" do
    it "should report just the total number of tests" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(88)
      @feedback.should_receive(:failure_count).and_return(0)
      @feedback.should_receive(:error_count).and_return(0)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("88 tests executed")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)
    end
    
    it "should report the number of tests and failures" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(30)
      @feedback.should_receive(:failure_count).at_least(:once).and_return(12)
      @feedback.should_receive(:error_count).and_return(0)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("30 tests executed")
      @feedback.should_receive(:print).with(", 12 failures")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)      
    end

    it "should report the number of tests and errors" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(3)
      @feedback.should_receive(:failure_count).and_return(0)
      @feedback.should_receive(:error_count).at_least(:once).and_return(1)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("3 tests executed")
      @feedback.should_receive(:print).with(", 1 errors")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)      
    end

    it "should report the number of tests, failures, and errors" do
      suite = mock("suite")
    
      suite.should_receive(:size).and_return(78)
      @feedback.should_receive(:failure_count).at_least(:once).and_return(9)
      @feedback.should_receive(:error_count).at_least(:once).and_return(3)
      @feedback.should_receive(:print).with("\n")
      @feedback.should_receive(:print).with("78 tests executed")
      @feedback.should_receive(:print).with(", 9 failures")
      @feedback.should_receive(:print).with(", 3 errors")
      @feedback.should_receive(:print).with(".\n")
    
      @feedback.post_tests(suite)      
    end
  end
  
  describe "reporting on a processor" do
    before(:each) do
      @light = mock("light")
      @processor = mock("processor")
      @processor.should_receive(:light).at_least(:once).and_return(@light)
    end
    
    it "should report a green light" do
      @feedback.should_receive(:putc).with(".")
      expect_light(:green)
      
      @feedback.processor_result(@processor)
    end
    
    it "should report a red light" do
      expect_light(:red)
      @feedback.should_receive(:putc).with("F")
      @feedback.should_receive(:increment_failure_count)
      
      @feedback.processor_result(@processor)
    end
    
    it "should report a yellow light" do      
      expect_light(:yellow)
      @feedback.should_receive(:putc).with("E")
      @feedback.should_receive(:increment_error_count)

      @feedback.processor_result(@processor)
    end

    it "should report an unset light" do      
      expect_light(:unset)
      @feedback.should_receive(:putc).with("-")
      
      @feedback.processor_result(@processor)
    end
    
    def expect_light(setting)
      @light.should_receive(:setting).at_least(:once).and_return(setting)
    end
  end
  
  describe "failure count" do
    it "should be zero initially" do
      @feedback.failure_count.should == 0
    end
    
    it "should increment" do
      @feedback.increment_failure_count
      
      @feedback.failure_count.should == 1
    end

    it "should increment lots" do
      1000.times { @feedback.increment_failure_count }
      
      @feedback.failure_count.should == 1000
    end
  end

  describe "error count" do
    it "should be zero initially" do
      @feedback.error_count.should == 0
    end
    
    it "should increment" do
      @feedback.increment_error_count
      
      @feedback.error_count.should == 1
    end

    it "should increment lots" do
      666.times { @feedback.increment_error_count }
      
      @feedback.error_count.should == 666
    end
    
    it "should not interfere with failure count" do
      666.times { @feedback.increment_failure_count }
      777.times { @feedback.increment_error_count }
      
      @feedback.failure_count.should == 666
      @feedback.error_count.should == 777
    end
  end
end
