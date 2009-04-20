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

describe CIAT::Crate, "processing a CIAT file" do
  before(:each) do
    @crate = CIAT::Crate.new(mock("filename"), mock("output folder"))
  end
  
  describe "processing test file" do
    it "should split and write" do
      raw_elements = {
        :e0 => mock("raw element 0"), :e1 => mock("raw element 1"), 
        :e2 => mock("raw element 2") }
      filenames = [mock("filename 0"), mock("filename 1"), mock("filename 2")]
      elements = { 
        :e0 => mock("element 0"), :e1 => mock("element 1"), 
        :e2 => mock("element 2") }

      @crate.should_receive(:split_test_file).and_return(raw_elements)
      @crate.should_receive(:filename).with(:e0).and_return(filenames[0])
      @crate.should_receive(:filename).with(:e1).and_return(filenames[1])
      @crate.should_receive(:filename).with(:e2).and_return(filenames[2])
      CIAT::TestElement.should_receive(:new).
        with(:e0, filenames[0], raw_elements[:e0]).and_return(elements[:e0])
      CIAT::TestElement.should_receive(:new).
        with(:e1, filenames[1], raw_elements[:e1]).and_return(elements[:e1])
      CIAT::TestElement.should_receive(:new).
        with(:e2, filenames[2], raw_elements[:e2]).and_return(elements[:e2])
      
      @crate.process_test_file.should == elements
    end
  end
  
  describe "splitting a test file" do
    it "should split just a description" do
      expect_file_content("description only\n")
      @crate.split_test_file.should == { :description => "description only\n" }
    end
    
    it "should split description and something else" do
      expect_file_content("description\n", "==== tag\n", "content\n")
      @crate.split_test_file.should == { :description => "description\n", :tag => "content\n" }
    end
    
    it "should split the test file" do
      expect_file_content("d\n", "==== source\n", "s\n",
        "==== compilation_expected \n", "p\n",
        "==== output_expected\n", "o\n")
      @crate.split_test_file.should == { :description => "d\n",
        :source => "s\n", :compilation_expected => "p\n", :output_expected => "o\n" }
    end
    
    it "should allow spaces in element name" do
      expect_file_content("description\n" , "==== element name\n", "content\n")
      @crate.split_test_file.should == {
        :description => "description\n", :element_name => "content\n" }
    end
    
    def expect_file_content(*content)
      @crate.should_receive(:read_test_file).and_return(content)
    end
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
