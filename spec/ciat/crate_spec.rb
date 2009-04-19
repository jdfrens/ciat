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
  
  it "should have a stub" do
    @crate.stub.should == "ciat/filename"
  end  
  
  #
  # Helpers
  #
  def mock_and_expect_filename_and_contents(type, content)
    filename = mock_and_expect_filename(type)
    @crate.should_receive(:write_file).with(filename, content)
  end
  
  def mock_and_expect_filename(type)
    filename = mock(type.to_s + " filename")
    @crate.should_receive(:filename).with(type).and_return(filename)
    filename
  end
end

describe CIAT::Crate, "generating actual file names" do
  before(:each) do
    @output_folder = "outie"
    @crate = CIAT::Crate.new("ciat/phile.ciat", @output_folder)
  end
  
  it "should work with no modifiers" do
    @crate.filename().should == "outie/ciat/phile"
  end
  
  it "should work with multiple modifiers" do
    @crate.filename("one", "two", "three").should == "outie/ciat/phile_one_two_three"
  end
end
