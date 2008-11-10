require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::TestElement do
  before(:each) do
    @filename = mock("filename")
    @content = mock("content")
    @element = CIAT::TestElement.new(@filename, @content)
  end
  
  it "should be written as a file" do
    CIAT::Cargo.should_receive(:write_file).with(@filename, @content)
    
    @element.as_file.should == @filename
  end
end
