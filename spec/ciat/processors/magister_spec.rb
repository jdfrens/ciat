require File.dirname(__FILE__) + '/../../spec_helper'

describe CIAT::Processors::Magister do
  before(:each) do
    @processor = mock("processor")
    @magister = CIAT::Processors::Magister.new(@processor)
  end
  
  it "should defer description" do
    description = mock("description")
    
    @processor.should_receive(:description).with(:description).and_return(description)
    
    @magister.description.should == description
  end
  
  it "should defer description of optional element" do
    description = mock("description")
    
    @processor.should_receive(:description).with(:optional).and_return(description)
    
    @magister.description(:optional).should == description
  end
  
  it "should defer processing" do
    crate, result = mock("crate"), mock("result")
    
    @processor.should_receive(:process).with(crate).and_return(result)
    
    @magister.process(crate).should == result
  end
  
  it "should defer required elements" do
    requireds = mock("requireds")
    
    @processor.should_receive(:required_elements).and_return(requireds)
    
    @magister.required_elements.should == requireds
  end
  
  it "should defer optional elements" do
    optionals = mock("optionals")
    
    @processor.should_receive(:optional_elements).and_return(optionals)
    
    @magister.optional_elements.should == optionals
  end
  
  it "should defer checked files" do
    crate, files = mock("crate"), mock("files")
    
    @processor.should_receive(:checked_files).with(crate).and_return(files)
    
    @magister.checked_files(crate).should == files
  end
  
  it "should have a light" do
    @magister.light.should be_kind_of(CIAT::TrafficLight)
  end
end
