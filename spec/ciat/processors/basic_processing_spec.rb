require File.dirname(__FILE__) + '/../../spec_helper'

describe CIAT::Processors::BasicProcessing do
  class Processor
    include CIAT::Processors::BasicProcessing
  end
  
  before(:each) do
    @processor = Processor.new
  end
  
  it "should look up relevant elements" do
    test = mock("test")
    names = [mock("name 0"), mock("name 1"), mock("name 2")]
    elements = [mock("element 0"), mock("element 1"), mock("element 2")]
    
    @processor.should_receive(:relevant_element_names).and_return(names)
    test.should_receive(:element?).with(names[0]).and_return(true)
    test.should_receive(:element).with(names[0]).and_return(elements[0])
    test.should_receive(:element?).with(names[1]).and_return(true)
    test.should_receive(:element).with(names[1]).and_return(elements[1])
    test.should_receive(:element?).with(names[2]).and_return(true)
    test.should_receive(:element).with(names[2]).and_return(elements[2])
    
    @processor.relevant_elements(test).should == elements
  end

  it "should look up only provided, relevant elements" do
    test = mock("test")
    names = [mock("name 0"), mock("name 1"), mock("name 2")]
    elements = [mock("element 0"), mock("element 2")]
    
    @processor.should_receive(:relevant_element_names).and_return(names)
    test.should_receive(:element?).with(names[0]).and_return(true)
    test.should_receive(:element).with(names[0]).and_return(elements[0])
    test.should_receive(:element?).with(names[1]).and_return(false)
    test.should_receive(:element?).with(names[2]).and_return(true)
    test.should_receive(:element).with(names[2]).and_return(elements[1])
    
    @processor.relevant_elements(test).should == elements
  end
  
  describe "handling command-line arguments" do
    it "should strip command-line arguments" do
      test = mock("test")
      command_line = mock("command_line")
    
      test.should_receive(:element?).with(:command_line).and_return(true)
      test.should_receive(:element).with(:command_line).and_return(command_line)
      command_line.should_receive(:content).and_return("   argument1 \t argument2  \n\n")
    
      @processor.command_line_args(test).should == "argument1 \t argument2"
    end
    
    it "should return empty string if none provided" do
      test = mock("test")
      
      test.should_receive(:element?).with(:command_line).and_return(false)
      
      @processor.command_line_args(test).should == ''
    end
  end
end
