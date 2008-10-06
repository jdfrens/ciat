require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Crate, "generating interesting names" do
  before(:each) do
    @cargo = mock("cargo")
    @crate = CIAT::Crate.new("ciat/filename.ciat", @cargo)
    @expected_filename = mock("expected filename")
  end
    
  it "should have a test file" do
    @crate.test_file.should == "ciat/filename.ciat"
  end
  
  it "should have a stub" do
    @crate.stub.should == "ciat/filename"
  end  
  
  it "should have a parent cargo" do
    @crate.cargo.should == @cargo
  end
  
  describe "provided elements" do
    it "should consult the elements hash" do
      @crate.should_receive(:elements).and_return({ :foo => "foo" })
      
      @crate.provided_elements.should == [:foo].to_set
    end
  end
  
  describe "processing test file" do
    it "should split and write" do
      elements1, elements2 = mock("elements 1"), mock("elements 2")
      @crate.should_receive(:split_test_file).and_return(elements1)
      @crate.should_receive(:write_output_files).with(elements1).and_return(elements2)
      
      @crate.process_test_file.should == elements2
    end
  end

  describe "splitting a test file" do
    before(:each) do
      @filename = mock("filename")
      @crate.should_receive(:test_file).and_return(@filename)
    end

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
      File.should_receive(:readlines).with(@filename).and_return(content)
    end
  end

  describe "writing output files" do
    it "should write no files when no elements" do
      @crate.write_output_files({}).should == {}
    end
    
    it "should write three files for three elements" do
      elements = {
        :one => mock("element 1"), :two => mock("element 2"), :three => mock("element 3")
        }
      
      mock_and_expect_filename_and_contents(:one, elements[:one])
      mock_and_expect_filename_and_contents(:two, elements[:two])
      mock_and_expect_filename_and_contents(:three, elements[:three])
      
      @crate.write_output_files(elements).should == elements
    end
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
    @cargo = mock("cargo", :output_folder => "outie")
    @crate = CIAT::Crate.new("ciat/phile.ciat", @cargo)
  end
  
  it "should work with no modifiers" do
    @crate.filename().should == "outie/ciat/phile"
  end
  
  it "should work with multiple modifiers" do
    @crate.filename("one", "two", "three").should == "outie/ciat/phile_one_two_three"
  end
  
  it "should generate expected-generated-diff triples" do
    triple = [mock("expected"), mock("generated"), mock("diff")]
    
    @crate.should_receive(:filename).with(:foo).and_return(triple[0])
    @crate.should_receive(:filename).with(:foo, :generated).and_return(triple[1])
    @crate.should_receive(:filename).with(:foo, :diff).and_return(triple[2])
    
    @crate.diff_filenames(:foo).should == triple
  end
end

describe CIAT::Crate, "file manipulation" do
  it "should write a file with cargo" do
    cargo = mock("cargo")
    crate = CIAT::Crate.new("NOT USED", cargo)
    cargo.should_receive(:write_file).with("phile.txt", "contents")
    
    crate.write_file("phile.txt", "contents")
  end

  it "should read a file with cargo" do
    cargo, contents = mock("cargo"), mock("contents")
    crate = CIAT::Crate.new("NOT USED", cargo)
    cargo.should_receive(:read_file).with("phile.txt").and_return(contents)
    
    crate.read_file("phile.txt").should == contents
  end
end