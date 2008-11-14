require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::TestElement do
  before(:each) do
    @name = mock("name")
    @filename = mock("filename")
    @content = mock("content")
    @element = CIAT::TestElement.new(@name, @filename, @content)
  end
  
  describe "treating as a file" do
    it "should be written as a file when interesting content" do
      CIAT::Cargo.should_receive(:write_file).with(@filename, @content)

      @element.as_file.should == @filename
    end

    it "should just return filename for pending content" do
      CIAT::Cargo.should_not_receive(:write_file)

      CIAT::TestElement.new(:some_name, @filename, nil).as_file.should == @filename
    end
  end
  
  describe "having content" do
    it "should have cached content" do
      @element.content.should == @content
    end
    
    it "should read when content is empty" do
      read_content = mock("read content")
      
      CIAT::Cargo.should_receive(:read_file).with(@filename).and_return(read_content)
      
      CIAT::TestElement.new(:some_name, @filename, nil).content.should == read_content
    end
  end
end
