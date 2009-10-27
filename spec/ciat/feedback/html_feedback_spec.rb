require File.dirname(__FILE__) + '/../../spec_helper'

require 'ciat/feedback/html_feedback'

describe CIAT::Feedback::HtmlFeedback do
  before(:each) do
    @counter = mock("counter")
    @feedback = CIAT::Feedback::HtmlFeedback.new(@counter, {})
  end

  it "should have a pre-test action" do
    suite, output_folder = mock("suite"), mock("output folder")

    suite.should_receive(:output_folder).
      at_least(:once).and_return(output_folder)
    FileUtils.should_receive(:mkdir_p).with(output_folder)
    FileUtils.should_receive(:cp).with(/.*\/data\/ciat.css/, output_folder)
    FileUtils.should_receive(:cp).with(/.*\/data\/prototype.js/, output_folder)
    
    @feedback.pre_tests(suite)
  end
  
  it "should generate a report" do
    suite = mock("suite")
    html, report_filename = mock("html"), mock("report filename")

    @feedback.should_receive(:generate_html).with(suite).and_return(html)
    @feedback.should_receive(:report_filename).and_return(report_filename)
    @feedback.should_receive(:write_file).with(report_filename, html)
    
    @feedback.post_tests(suite)
  end
  
  it "should generate html" do
    suite = mock("suite")
    erb_template, binding = mock("erb_template"), mock("binding")
    filename = mock("filename")
    
    suite.should_receive(:results).and_return(mock("results"))
    suite.should_receive(:processors).and_return(mock("processors"))
    suite.should_receive(:size).and_return(mock("size"))
    @feedback.should_receive(:build_erb).and_return(erb_template)
    @feedback.should_receive(:binding).with().and_return(binding)
    erb_template.should_receive(:result).with(binding)
    
    @feedback.generate_html(suite)
  end
end
