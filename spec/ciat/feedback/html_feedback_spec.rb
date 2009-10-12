require File.dirname(__FILE__) + '/../../spec_helper'

require 'ciat/feedback/html_feedback'

describe CIAT::Feedback::HtmlFeedback do
  before(:each) do
    @counter = mock("counter")
    @feedback = CIAT::Feedback::HtmlFeedback.new(@counter)
  end
  
  it "should have a pre-test action" do
    suite, cargo = mock("suite"), mock("cargo")
    
    suite.should_receive(:cargo).and_return(cargo)
    cargo.should_receive(:copy_suite_data)
    
    @feedback.pre_tests(suite)
  end
  
  it "should generate a report" do
    suite = mock("suite")
    cargo = mock("cargo")
    html, report_filename = mock("html"), mock("report filename")

    suite.should_receive(:cargo).any_number_of_times.and_return(cargo)
    @feedback.should_receive(:generate_html).with(suite).and_return(html)
    cargo.should_receive(:report_filename).and_return(report_filename)
    CIAT::Cargo.should_receive(:write_file).with(report_filename, html)
    
    @feedback.post_tests(suite)
  end
  
  it "should generate html" do
    suite = mock("suite")
    erb_template, binding = mock("erb_template"), mock("binding")
    filename, results = mock("filename")
    
    suite.should_receive(:results).and_return(mock("results"))
    suite.should_receive(:processors).and_return(mock("processors"))
    suite.should_receive(:report_title).and_return(mock("report title"))
    suite.should_receive(:size).and_return(mock("size"))
    @feedback.should_receive(:template).and_return(filename)
    ERB.should_receive(:new).with(filename).and_return(erb_template)
    @feedback.should_receive(:binding).with().and_return(binding)
    erb_template.should_receive(:result).with(binding)
    
    @feedback.generate_html(suite)
  end
end
