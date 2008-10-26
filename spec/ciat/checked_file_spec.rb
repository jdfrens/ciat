require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::CheckedFile do
  it "should create" do
    crate = mock("crate")
    checked_files = [mock("file 0"), mock("file 1"), mock("file 2")]
    
    CIAT::CheckedFile.should_receive(:new).with(crate, :one).and_return(checked_files[0])
    CIAT::CheckedFile.should_receive(:new).with(crate, :two).and_return(checked_files[1])
    CIAT::CheckedFile.should_receive(:new).with(crate, :three).and_return(checked_files[2])

    CIAT::CheckedFile.create(crate, :one, :two, :three).should == checked_files
  end
  
  describe "the three files" do
    before(:each) do
      @crate = mock("crate")
      @modifier = mock("modifier")
      @checked_file = CIAT::CheckedFile.new(@crate, @modifier)
    end
    
    it "should compute the filename of expected" do
      result = mock("result")
      
      @crate.should_receive(:filename).with(@modifier).and_return(result)
      
      @checked_file.expected.should == result
    end
    
    it "should compute the filename of generated" do
      result = mock("result")
      
      @crate.should_receive(:filename).with(@modifier, :generated).and_return(result)
      
      @checked_file.generated.should == result
    end
    
    it "should compute the filename of diff" do
      result = mock("result")
      
      @crate.should_receive(:filename).with(@modifier, :diff).and_return(result)
      
      @checked_file.diff.should == result
    end
  end
end
