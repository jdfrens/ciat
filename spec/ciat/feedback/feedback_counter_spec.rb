require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/standard_output'

describe CIAT::Feedback::FeedbackCounter do
  before(:each) do
    @feedback = CIAT::Feedback::FeedbackCounter.new
  end
  
  describe "error count" do
    it "should be zero initially" do
      @feedback.error_count.should == 0
    end
    
    it "should increment" do      
      @feedback.report_subresult(yellow_subresult)
      
      @feedback.error_count.should == 1
    end

    it "should increment lots" do
      666.times { @feedback.report_subresult(yellow_subresult) }
      
      @feedback.error_count.should == 666
    end
  end
    
  describe "failure count" do
    it "should be zero initially" do
      @feedback.failure_count.should == 0
    end
    
    it "should increment" do      
      @feedback.report_subresult(red_subresult)
      
      @feedback.failure_count.should == 1
    end

    it "should increment lots" do
      666.times { @feedback.report_subresult(red_subresult) }
      
      @feedback.failure_count.should == 666
    end
  end
    
  it "should keep distinct counts" do
    666.times { @feedback.report_subresult(yellow_subresult) }
    777.times { @feedback.report_subresult(red_subresult) }
    111.times { @feedback.report_subresult(unset_subresult) }
    444.times { @feedback.report_subresult(green_subresult) }
    
    @feedback.failure_count.should == 777
    @feedback.error_count.should == 666
  end
  
  def red_subresult
    mock("red subresult", :light => CIAT::TrafficLight::RED)
  end

  def yellow_subresult
    mock("yellow subresult", :light => CIAT::TrafficLight::YELLOW)
  end

  def green_subresult
    mock("green subresult", :light => CIAT::TrafficLight::GREEN)
  end

  def unset_subresult
    mock("unset subresult", :light => CIAT::TrafficLight::UNSET)
  end
end
