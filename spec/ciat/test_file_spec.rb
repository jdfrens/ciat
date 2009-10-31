require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::TestFile do
  before(:each) do
    File.should_receive(:exists?).with(anything).
      any_number_of_times.and_return(true)
    @test_file = CIAT::TestFile.new(mock("filename"), mock("output folder"))
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

      @test_file.should_receive(:split).and_return(raw_elements)
      @test_file.should_receive(:filename).with(:e0).and_return(filenames[0])
      @test_file.should_receive(:filename).with(:e1).and_return(filenames[1])
      @test_file.should_receive(:filename).with(:e2).and_return(filenames[2])
      CIAT::TestElement.should_receive(:new).
        with(:e0, filenames[0], raw_elements[:e0]).and_return(elements[:e0])
      CIAT::TestElement.should_receive(:new).
        with(:e1, filenames[1], raw_elements[:e1]).and_return(elements[:e1])
      CIAT::TestElement.should_receive(:new).
        with(:e2, filenames[2], raw_elements[:e2]).and_return(elements[:e2])
      
      @test_file.process.should == elements
    end
  end
  
  describe "splitting a test file" do
    it "should split just a description" do
      expect_file_content("description only\n")
      @test_file.split.should == { :description => "description only\n" }
    end
    
    it "should split description and something else" do
      expect_file_content("description\n", "==== tag\n", "content\n")
      @test_file.split.should == { :description => "description\n", :tag => "content\n" }
    end
    
    it "should split the test file" do
      expect_file_content("d\n", "==== source\n", "s\n",
        "==== compilation_expected \n", "p\n",
        "==== output_expected\n", "o\n")
      @test_file.split.should == { :description => "d\n",
        :source => "s\n", :compilation_expected => "p\n", :output_expected => "o\n" }
    end
    
    it "should allow spaces in element name" do
      expect_file_content("description\n" , "==== element name\n", "content\n")
      @test_file.split.should == {
        :description => "description\n", :element_name => "content\n" }
    end
    
    def expect_file_content(*content)
      @test_file.should_receive(:read).and_return(content)
    end
  end
end

describe CIAT::TestFile, "generating actual file names" do
  before(:each) do
    File.should_receive(:exists?).with(anything).
      any_number_of_times.and_return(true)
    @output_folder = "outie"
    @test_file = CIAT::TestFile.new("ciat/phile.ciat", @output_folder)
  end
  
  it "should return the original filename" do
    @test_file.filename(:ciat).should == "ciat/phile.ciat"
  end
  
  it "should work with no modifiers" do
    @test_file.filename().should == "outie/ciat/phile"
  end
  
  it "should work with multiple modifiers" do
    @test_file.filename("one", "two", "three").should == "outie/ciat/phile_one_two_three"
  end
end

describe CIAT::TestFile, "constructor errors" do
  it "should complain about a missing file" do
    File.should_receive(:exists?).
      with("does-not-exist.ciat").and_return(false)
    
    lambda {
      CIAT::TestFile.new("does-not-exist.ciat", nil)
    }.should raise_error(IOError)
  end
end
