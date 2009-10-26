require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::Subtest do
  # SMELL: get construction code into before(:each)
  it "should get executable from processor" do
    processor = mock("processor")
    executable = mock("executable")
    
    processor.should_receive(:executable).and_return(executable)
    
    CIAT::SubTest.new(mock("test file"), processor).executable.should == executable
  end
end
