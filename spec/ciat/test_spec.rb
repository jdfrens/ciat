require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
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
      @subresults = [mock("subresult 0"), 
        mock("subresult 1"), mock("subresult 2")]
    end
    
    it "should run just the first processor" do
      light = mock("light", :green? => false)
      
      @processors[0].should_receive(:process).with(@test).
        and_return(light)
      @test.should_receive(:subresult).with(@processors[0], light).
        and_return(@subresults[0])
      @test.should_receive(:subresult).with(@processors[1]).
        and_return(@subresults[1])
      @test.should_receive(:subresult).with(@processors[2]).
        and_return(@subresults[2])
      
      @test.run_processors.should == @subresults
    end

    it "should run just the first two processors" do
      lights = [mock("light 0", :green? => true), 
                mock("light 1", :green? => false)]
      
      @processors[0].should_receive(:process).with(@test).
        and_return(lights[0])
      @test.should_receive(:subresult).with(@processors[0], lights[0]).
        and_return(@subresults[0])
      @processors[1].should_receive(:process).with(@test).
        and_return(lights[1])
      @test.should_receive(:subresult).with(@processors[1], lights[1]).
        and_return(@subresults[1])
      @test.should_receive(:subresult).with(@processors[2]).
        and_return(@subresults[2])
      
      @test.run_processors.should == @subresults
    end

    it "should run just all processors" do
      lights = [mock("light 0", :green? => true),
                mock("light 1", :green? => true), mock("light 2")]

      @processors[0].should_receive(:process).with(@test).
        and_return(lights[0])
      @test.should_receive(:subresult).with(@processors[0], lights[0]).
        and_return(@subresults[0])
      @processors[1].should_receive(:process).with(@test).
        and_return(lights[1])
      @test.should_receive(:subresult).with(@processors[1], lights[1]).
        and_return(@subresults[1])
      @processors[2].should_receive(:process).with(@test).
        and_return(lights[2])
      @test.should_receive(:subresult).with(@processors[2], lights[2]).
        and_return(@subresults[2])
      
      @test.run_processors.should == @subresults
    end
  end
  
  it "should processor subresult" do
    light, processor = mock("light"), mock("processor")
    subresult = mock("subresult")
    
    CIAT::Subresult.should_receive(:new).with(@test, light, processor).
      and_return(subresult)
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