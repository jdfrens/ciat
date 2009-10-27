require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::Subresult do
  before(:each) do
    @elements = mock("elements")
    @light = mock("light")
    @processor = mock("processor")
    
    @subtest_result = CIAT::Subresult.new(@elements, @light, @processor)
  end
  
  it "should look up relevant elements" do
    test = mock("test")
    names = [mock("name 0"), mock("name 1"), mock("name 2")]
    relevants = [mock("element 0"), mock("element 1"), mock("element 2")]
    
    @subtest_result.should_receive(:relevant_element_names).and_return(names)
    @elements.should_receive(:element?).with(names[0]).and_return(true)
    @elements.should_receive(:element).with(names[0]).and_return(relevants[0])
    @elements.should_receive(:element?).with(names[1]).and_return(true)
    @elements.should_receive(:element).with(names[1]).and_return(relevants[1])
    @elements.should_receive(:element?).with(names[2]).and_return(true)
    @elements.should_receive(:element).with(names[2]).and_return(relevants[2])
    
    @subtest_result.relevant_elements.should == relevants
  end
  
  it "should have relevant element names" do
    kind, hash, setting = 
      mock("kind"), mock("hash"), mock("setting")
    names = mock("names")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:element_name_hash).and_return(hash)
    @light.should_receive(:setting).and_return(setting)
    hash.should_receive(:[]).with(setting).and_return(names)
    
    @subtest_result.relevant_element_names.should == names
  end
end