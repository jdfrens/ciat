require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::RakeTask do
  it "should initialize" do
    CIAT::RakeTask.new.should_not be_nil
  end

  it "should let me set processors" do
    processors = mock("processors")
    CIAT::RakeTask.new do |task|
      task.processors = processors
    end.processors.should == processors
  end
  
  it "should let me append processors" do
    processors = array_of_mocks(3, "processor")
    CIAT::RakeTask.new do |task|
      task.processors << processors[0]
      task.processors << processors[1]
      task.processors << processors[2]
    end.processors.should == processors
  end
  
  it "should let me set the files for input" do
    files = mock("file")
    CIAT::RakeTask.new do |task|
      task.files = files
    end.files.should == files
  end
  
  it "should let me set the feedback" do
    feedback = mock("feedback")
    CIAT::RakeTask.new do |task|
      task.feedback = feedback
    end.feedback.should == feedback
  end
  
  it "should let set the folder for input files" do
    folder = mock("folder")
    CIAT::RakeTask.new do |task|
      task.folder = folder
    end.folder.should == folder
  end
  
  it "should let me set the report filename" do
    report_filename = mock("report filename")
    CIAT::RakeTask.new do |task|
      task.report_filename = report_filename
    end.report_filename.should == report_filename
  end
  
  it "should let me set the report title" do
    report_title = mock("report title")
    CIAT::RakeTask.new do |task|
      task.report_title = report_title
    end.report_title.should == report_title
  end

  it "should let me set the output folder" do
    output_folder = mock("output folder")
    CIAT::RakeTask.new do |task|
      task.output_folder = output_folder
    end.output_folder.should == output_folder
  end
end
