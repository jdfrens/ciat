require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Crate, "generating interesting names" do
  before(:each) do
    @output_folder = mock("output folder")
    @crate = CIAT::Crate.new("ciat/filename.ciat", @output_folder)
    @expected_filename = mock("expected filename")
  end
    
  it "should have a test file" do
    @crate.test_file.should == "ciat/filename.ciat"
  end
  
  it "should have a basename" do
    @crate.basename.should == "filename"
  end
  
  it "should have a folder name" do
    @crate.folder_name.should == "ciat"
  end

  it "should have a source file" do
    set_expected_output_modifiers("source")
    @crate.source.should == @expected_filename
  end
  
  it "should have a compilation_expected file" do
    set_expected_output_modifiers("compilation", "expected")
    @crate.compilation_expected.should == @expected_filename
  end
  
  it "should have a compilation_generated file" do
    set_expected_output_modifiers("compilation", "generated")
    @crate.compilation_generated.should == @expected_filename
  end
  
  it "should have a output_expected file" do
    set_expected_output_modifiers("output", "expected")
    @crate.output_expected.should == @expected_filename
  end
  
  it "should have a output_generated file" do
    set_expected_output_modifiers("output", "generated")
    @crate.output_generated.should == @expected_filename    
  end
  
  it "should have a compilation_diff file" do
    set_expected_output_modifiers("compilation", "diff")
    @crate.compilation_diff.should == @expected_filename    
  end
  
  it "should have a output_diff file" do
    set_expected_output_modifiers("output", "diff")
    @crate.output_diff.should == @expected_filename    
  end
  
  it "should have an output folder" do
    @crate.output_folder.should == @output_folder
  end
  
  def set_expected_output_modifiers(*modifiers)
    @crate.should_receive(:output_filename).with(*modifiers).and_return(@expected_filename)    
  end
end

describe CIAT::Crate, "generating actual file names" do
  before(:each) do
    @crate = CIAT::Crate.new("philenamus", "outie")
  end
  
  it "should work with no modifiers" do
    @crate.output_filename().should == "outie/philenamus"
  end
  
  it "should work with multiple modifiers" do
      @crate.output_filename("one", "two", "three").should == "outie/philenamus_one_two_three"
  end
end