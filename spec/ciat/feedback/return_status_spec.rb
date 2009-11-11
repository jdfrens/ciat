require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/feedback/return_status'

describe CIAT::Feedback::ReturnStatus do
  GREEN = CIAT::TrafficLight::GREEN
  YELLOW = CIAT::TrafficLight.new(:yellow)
  RED = CIAT::TrafficLight.new(:red)
  
  before(:each) do
    @feedback = CIAT::Feedback::ReturnStatus.new
  end
  
  describe "notification after tests have been run" do
    it "should be okay without any tests" do
      lambda { @feedback.post_tests(mock("suite")) }.should_not raise_error
    end
  end

  describe "reporting a subresult with a happy path" do
    it "should ignore a green light" do
      @feedback.report_subresult(mock("subtest", :light => GREEN))
    
      lambda { @feedback.post_tests(mock("suite")) }.should_not raise_error
    end

    it "should fail after yellow subtest" do
      @feedback.report_subresult(mock("subtest", :light => YELLOW))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end
  
    it "should fail after red subtest" do
      @feedback.report_subresult(mock("subtest", :light => RED))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end
  end

  describe "reporting multiple subresults" do
    it "should ignore many green lights" do
      @feedback.report_subresult(mock("subtest", :light => GREEN))
      @feedback.report_subresult(mock("subtest", :light => GREEN))
      @feedback.report_subresult(mock("subtest", :light => GREEN))
    
      lambda { @feedback.post_tests(mock("suite")) }.should_not raise_error
    end
  
    it "should fail after many yellow subtests" do
      @feedback.report_subresult(mock("subtest", :light => YELLOW))
      @feedback.report_subresult(mock("subtest", :light => YELLOW))
      @feedback.report_subresult(mock("subtest", :light => YELLOW))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end

    it "should fail after many red subtests" do
      @feedback.report_subresult(mock("subtest", :light => RED))
      @feedback.report_subresult(mock("subtest", :light => RED))
      @feedback.report_subresult(mock("subtest", :light => RED))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end

    it "should fail after many different subtests (red last)" do
      @feedback.report_subresult(mock("subtest", :light => GREEN))
      @feedback.report_subresult(mock("subtest", :light => YELLOW))
      @feedback.report_subresult(mock("subtest", :light => RED))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end

    it "should fail after many different subtests (yellow last)" do
      @feedback.report_subresult(mock("subtest", :light => GREEN))
      @feedback.report_subresult(mock("subtest", :light => RED))
      @feedback.report_subresult(mock("subtest", :light => YELLOW))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end

    it "should fail after many different subtests (green last)" do
      @feedback.report_subresult(mock("subtest", :light => YELLOW))
      @feedback.report_subresult(mock("subtest", :light => RED))
      @feedback.report_subresult(mock("subtest", :light => GREEN))

      lambda { @feedback.post_tests(mock("suite")) }.
        should raise_error(RuntimeError)
    end
  end
end
