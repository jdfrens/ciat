require File.dirname(__FILE__) + '/../../spec_helper'

describe CIAT::Processors::Magister do
  before(:each) do
    @processor = mock("processor")
    @magister = CIAT::Processors::Magister.new(@processor)
  end
  
  it "should defer description" do
    description = mock("description")
    
    @processor.should_receive(:description).and_return(description)
    
    @magister.description.should == description
  end
  
  it "should defer processing" do
    crate, result = mock("crate"), mock("result")
    
    @processor.should_receive(:process).with(crate).and_return(result)
    
    @magister.process(crate).should == result
  end
  
  it "should defer checked files" do
    crate, files = mock("crate"), mock("files")
    
    @processor.should_receive(:checked_files).with(crate).and_return(files)
    
    @magister.checked_files(crate).should == files
  end
end
