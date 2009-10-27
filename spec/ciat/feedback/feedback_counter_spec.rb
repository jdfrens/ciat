require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/standard_output'

describe CIAT::Feedback::FeedbackCounter do
  before(:each) do
    @feedback = CIAT::Feedback::FeedbackCounter.new
  end
  
  describe "reporting on a processor" do
    before(:each) do
      @light = mock("light")
      @subresult = mock("subresult")
      @subresult.should_receive(:light).at_least(:once).and_return(@light)
    end
    
    it "should report a green light" do
      expect_light(:green)
      
      @feedback.report_subresult(@subresult)
    end
    
    it "should report a red light" do
      expect_light(:red)
      @feedback.should_receive(:increment_failure_count)
      
      @feedback.report_subresult(@subresult)
    end
    
    it "should report a yellow light" do      
      expect_light(:yellow)
      @feedback.should_receive(:increment_error_count)

      @feedback.report_subresult(@subresult)
    end

    it "should report an unset light" do      
      expect_light(:unset)
      
      @feedback.report_subresult(@subresult)
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
