require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  include MockHelpers
  
  before(:each) do
    @filename = mock("filename")
    @test_file = mock("test file")
    @processors = [mock("p 0"), mock("p 1"), mock("p 2")]
    @differ = mock("differ")
    @feedback = mock("feedback")
    @test = CIAT::Test.new(@test_file, @processors, @feedback)
  end

  describe "running a test" do
    it "should run a complete test" do
      subresults = mock("subresults")
      result = mock("result")
      
      @test.should_receive(:run_processors).and_return(subresults)
      CIAT::TestResult.should_receive(:new).with(@test, subresults).
        and_return(result)
      
      @test.run.should == result
    end
  end
  
  describe "running processors" do
    before(:each) do
      @subresults = array_of_mocks(3, "subresult")
    end
    
    it "should run just the first processor" do
      expect_not_green(@processors[0], @subresults[0])
      expect_unset(@processors[1], @subresults[1])
      expect_unset(@processors[2], @subresults[2])
      
      @test.run_processors.should == @subresults
    end
    
    it "should run just the first two processors" do
      expect_green(@processors[0], @subresults[0])
      expect_not_green(@processors[1], @subresults[1])
      expect_unset(@processors[2], @subresults[2])
      
      @test.run_processors.should == @subresults
    end

    it "should run all processors" do
      expect_green(@processors[0], @subresults[0])
      expect_green(@processors[1], @subresults[1])
      expect_green(@processors[2], @subresults[2])
            
      @test.run_processors.should == @subresults
    end

    def expect_green(processor, subresult)
      light = mock("light", :green? => true)
      processor.should_receive(:process).with(@test).and_return(light)
      @test.should_receive(:subresult).with(processor, light).
        and_return(subresult)
      subresult.should_receive(:light).and_return(light)
    end
    
    def expect_not_green(processor, subresult)
      light = mock("light", :green? => false)
      processor.should_receive(:process).with(@test).and_return(light)
      @test.should_receive(:subresult).with(processor, light).
        and_return(subresult)
      subresult.should_receive(:light).and_return(light)
    end
    
    def expect_unset(processor, subresult)
      @test.should_receive(:subresult).with(processor).and_return(subresult)
    end
  end
  
  it "should build and report subresult" do
    path_kind, light, processor = 
      mock("path kind"), mock("light"), mock("processor")
    subresult = mock("subresult")
    
    processor.should_receive(:path_kind).with(@test).and_return(path_kind)
    CIAT::Subresult.should_receive(:new).
      with(@test, path_kind, light, processor).and_return(subresult)
    @feedback.should_receive(:report_subresult).with(subresult)

    @test.subresult(processor, light).should == subresult
  end
  
  describe "processing elements" do
    before(:each) do
      @elements = mock("elements")
      @test.should_receive(:elements).and_return(@elements)
    end
    
    it "should return specified element" do
      element = mock("element")
    
      @elements.should_receive(:[]).with(:foo).and_return(element)
    
      @test.element(:foo).should == element
    end

    it "should return specified element with multi-word name" do
      element = mock("element")
    
      @elements.should_receive(:[]).with(:foo_bar_joe).and_return(element)
    
      @test.element(:foo, :bar, :joe).should == element
    end
  
    it "should check to see if element exists" do
      exists = mock("a boolean")
    
      @elements.should_receive(:has_key?).with(:foo_bar_joe).and_return(exists)
    
      @test.element?(:foo, :bar, :joe).should == exists
    end
  end
end