require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Crate, "generating interesting names" do
  before(:each) do
    @output_folder = mock("output folder")
    @ciat_names = CIAT::Crate.new("ciat/filename.ciat", @output_folder)
    @expected_filename = mock("expected filename")
  end
    
  it "should have a test file" do
    @ciat_names.test_file.should == "ciat/filename.ciat"
  end
  
  it "should have a basename" do
    @ciat_names.basename.should == "filename"
  end
  
  it "should have a folder name" do
    @ciat_names.folder_name.should == "ciat"
  end

  it "should have a source file" do
    set_expected_output_modifiers("source")
    @ciat_names.source.should == @expected_filename
  end
  
  it "should have a compilation_expected file" do
    set_expected_output_modifiers("compilation", "expected")
    @ciat_names.compilation_expected.should == @expected_filename
  end
  
  it "should have a compilation_generated file" do
    set_expected_output_modifiers("compilation", "generated")
    @ciat_names.compilation_generated.should == @expected_filename
  end
  
  it "should have a output_expected file" do
    set_expected_output_modifiers("output", "expected")
    @ciat_names.output_expected.should == @expected_filename
  end
  
  it "should have a output_generated file" do
    set_expected_output_modifiers("output", "generated")
    @ciat_names.output_generated.should == @expected_filename    
  end
  
  it "should have a compilation_diff file" do
    set_expected_output_modifiers("compilation", "diff")
    @ciat_names.compilation_diff.should == @expected_filename    
  end
  
  it "should have a output_diff file" do
    set_expected_output_modifiers("output", "diff")
    @ciat_names.output_diff.should == @expected_filename    
  end
  
  it "should have an output folder" do
    @ciat_names.output_folder.should == @output_folder
  end
  
  def set_expected_output_modifiers(*modifiers)
    @ciat_names.should_receive(:output_filename).with(*modifiers).and_return(@expected_filename)    
  end
end

describe CIAT::Crate, "generating actual file names" do
  before(:each) do
    @ciat_names = CIAT::Crate.new("philenamus", "outie")
  end
  
  it "should work with no modifiers" do
    @ciat_names.output_filename().should == "outie/philenamus"
  end
  
  it "should work with multiple modifiers" do
      @ciat_names.output_filename("one", "two", "three").should == "outie/philenamus_one_two_three"
  end
end