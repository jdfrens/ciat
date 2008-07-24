require File.dirname(__FILE__) + '/spec_helper.rb'

describe CIAT::Filenames do
  before(:each) do
    @filenames = CIAT::Filenames.new("filename")
  end
  
  it "should have a test file" do
    @filenames.test_file.should == "filename.txt"
  end

  it "should have a pir extension" do
    @filenames.expected_pir.should == "./work/filename_expected.pir"
  end

  it "should have a hobbes source file" do
    @filenames.hobbes_source.should == "./work/filename.hob"
  end
  
  it "should have a expected_pir file" do
    @filenames.expected_pir.should == "./work/filename_expected.pir"
  end
  
  it "should have a generated_pir file" do
    @filenames.generated_pir.should == "./work/filename_generated.pir"
  end
  
  it "should have a expected_output file" do
    @filenames.expected_output.should == "./work/filename_expected.out"
  end
  
  it "should have a generated_output file" do
    @filenames.generated_output.should == "./work/filename_generated.out"    
  end
  
  it "should have a pir_diff file" do
    @filenames.pir_diff.should == "./work/filename_pir.diff"    
  end
  
  it "should have a output_diff file" do
    @filenames.output_diff.should == "./work/filename_output.diff"    
  end
  
  it "should have a work_directory file" do
    @filenames.work_directory.should == "./work"
  end
  
end
