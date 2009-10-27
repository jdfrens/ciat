require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/return_status'

describe CIAT::Feedback::ReturnStatus do
  GREEN = CIAT::TrafficLight.new(:green)
  YELLOW = CIAT::TrafficLight.new(:yellow)
  RED = CIAT::TrafficLight.new(:red)
  
  before(:each) do
    @feedback = CIAT::Feedback::ReturnStatus.new
  end
  
  it "should be okay without any tests" do
    lambda { @feedback.post_tests(mock("suite")) }.should_not raise_error
  end
  
  it "should ignore a green light" do
    @feedback.report_subresult(mock("processor", :light => GREEN))
    
    lambda { @feedback.post_tests(mock("suite")) }.should_not raise_error
  end

  it "should ignore many green lights" do
    @feedback.report_subresult(mock("processor", :light => GREEN))
    @feedback.report_subresult(mock("processor", :light => GREEN))
    @feedback.report_subresult(mock("processor", :light => GREEN))
    
    lambda { @feedback.post_tests(mock("suite")) }.should_not raise_error
  end
  
  it "should fail after yellow processor" do
    @feedback.report_subresult(mock("processor", :light => YELLOW))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end
  
  it "should fail after many yellow processors" do
    @feedback.report_subresult(mock("processor", :light => YELLOW))
    @feedback.report_subresult(mock("processor", :light => YELLOW))
    @feedback.report_subresult(mock("processor", :light => YELLOW))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end

  it "should fail after red processor" do
    @feedback.report_subresult(mock("processor", :light => RED))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end
  
  it "should fail after many red processors" do
    @feedback.report_subresult(mock("processor", :light => RED))
    @feedback.report_subresult(mock("processor", :light => RED))
    @feedback.report_subresult(mock("processor", :light => RED))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end

  it "should fail after many different processors (red last)" do
    @feedback.report_subresult(mock("processor", :light => GREEN))
    @feedback.report_subresult(mock("processor", :light => YELLOW))
    @feedback.report_subresult(mock("processor", :light => RED))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end

  it "should fail after many different processors (yellow last)" do
    @feedback.report_subresult(mock("processor", :light => GREEN))
    @feedback.report_subresult(mock("processor", :light => RED))
    @feedback.report_subresult(mock("processor", :light => YELLOW))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end

  it "should fail after many different processors (green last)" do
    @feedback.report_subresult(mock("processor", :light => YELLOW))
    @feedback.report_subresult(mock("processor", :light => RED))
    @feedback.report_subresult(mock("processor", :light => GREEN))

    lambda { @feedback.post_tests(mock("suite")) }.
      should raise_error(RuntimeError)
  end
end