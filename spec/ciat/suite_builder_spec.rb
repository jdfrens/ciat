require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::SuiteBuilder do
  include MockHelpers
  
  before(:each) do
    @options = {}
    @default_builder = CIAT::SuiteBuilder.new(options)
  end
  
  it "should build default feedback" do
    @default_builder.build_feedback.
      should be_an_instance_of(CIAT::Feedback::Composite)
  end
  
  describe "making test files" do
    it "should make test files" do
      files = array_of_mocks(3, "files")
      output_folder = mock("output folder")
      ciat_files = array_of_mocks(3, "ciat file")

      @default_builder.should_receive(:build_output_folder).
        at_least(:once).and_return(output_folder)
      CIAT::CiatFile.should_receive(:new).
        with(files[0], output_folder).and_return(ciat_files[0])
      CIAT::CiatFile.should_receive(:new).
        with(files[1], output_folder).and_return(ciat_files[1])
      CIAT::CiatFile.should_receive(:new).
        with(files[2], output_folder).and_return(ciat_files[2])
    
      @default_builder.make_ciat_files(files).should == ciat_files
    end

    it "should complain if no test files to make" do
      lambda {
        @default_builder.make_ciat_files([])
      }.should raise_error(IOError)
    end
  end
  
  describe "getting and processing test files" do
    it "should get filename from filenames option" do
      files = mock("files")
      ciat_files = mock("ciat files")
      
      options[:files] = files
      @default_builder.should_receive(:make_ciat_files).
        with(files).and_return(ciat_files)
        
      @default_builder.build_ciat_files.should == ciat_files
    end
    
    it "should get filenames from folder" do
      input_folder, pattern = mock("input folder"), mock("pattern")
      files = mock("files")
      output_folder = mock("output folder")
      ciat_files = mock("ciat files")
      
      options[:folder] = input_folder
      options[:pattern] = pattern
      File.should_receive(:join).with(input_folder, "**", pattern).
        and_return("the full path")
      Dir.should_receive(:[]).with("the full path").and_return(files)
      @default_builder.should_receive(:make_ciat_files).
        with(files).and_return(ciat_files)
      
      @default_builder.build_ciat_files.should == ciat_files      
    end
  end
end
