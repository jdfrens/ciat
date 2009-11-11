require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::Subresult do
  before(:each) do
    @elements = mock("elements")
    @path_kind = mock("path kind")
    @light = mock("light")
    @subtest = mock("subtest")
    
    @subresult = CIAT::Subresult.new(@elements, @path_kind, @light, @subtest)
  end
  
  it "should look up relevant elements" do
    test = mock("test")
    names = [mock("name 0"), mock("name 1"), mock("name 2")]
    relevants = [mock("element 0"), mock("element 1"), mock("element 2")]
    
    @subresult.should_receive(:relevant_element_names).and_return(names)
    @elements.should_receive(:element?).with(names[0]).and_return(true)
    @elements.should_receive(:element).with(names[0]).and_return(relevants[0])
    @elements.should_receive(:element?).with(names[1]).and_return(true)
    @elements.should_receive(:element).with(names[1]).and_return(relevants[1])
    @elements.should_receive(:element?).with(names[2]).and_return(true)
    @elements.should_receive(:element).with(names[2]).and_return(relevants[2])
    
    @subresult.relevant_elements.should == relevants
  end
  
  it "should have relevant element names" do
    kind = mock("kind")
    path_kind = mock("path kind")
    names = mock("names")

    @subtest.should_receive(:path_kind).and_return(path_kind)
    @subtest.stub_chain(:processor, :kind).and_return(kind)
    kind.should_receive(:relevant_elements).
      with(@light, path_kind).and_return(names)
    
    @subresult.relevant_element_names.should == names
  end
end