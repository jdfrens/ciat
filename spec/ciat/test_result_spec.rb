require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::TestResult do
  before(:each) do
    @test = mock("test")
    @subresults = array_of_mocks(3, "subresult")
    @test_result = CIAT::TestResult.new(@test, @subresults)
  end
  
  it "should defer grouping to the test" do
    grouping = mock("grouping")
    @test.should_receive(:grouping).and_return(grouping)
    @test_result.grouping.should == grouping
  end
  
  it "should defer filename" do
    filename = mock("filename")
    @test.should_receive(:filename).with(:ciat).and_return(filename)
    @test_result.filename.should == filename
  end
  
  it "should defer element accessor" do
    element = mock("element")
    @test.should_receive(:element).
      with(:one, :two, :three).and_return(element)
    @test_result.element(:one, :two, :three).should == element
  end
  
  it "should get processors from subresults" do
    processors = array_of_mocks(3, "processor")
    @subresults[0].should_receive(:processor).and_return(processors[0])
    @subresults[1].should_receive(:processor).and_return(processors[1])
    @subresults[2].should_receive(:processor).and_return(processors[2])
    @test_result.processors.should == processors
  end
end
