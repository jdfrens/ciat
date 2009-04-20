require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @crate = mock("crate")
    @processors = [mock("p 0"), mock("p 1"), mock("p 2")]
    @differ = mock("differ")
    @lights = [mock("light 0"), mock("light 1"), mock("light 2")]
    @feedback = mock("feedback")
    @test = CIAT::Test.new(@crate,
      :processors => @processors,
      :differ => @differ,
      :feedback => @feedback)
    @processors[0].should_receive(:light).
      any_number_of_times.and_return(@lights[0])
    @processors[1].should_receive(:light).
      any_number_of_times.and_return(@lights[1])
    @processors[2].should_receive(:light).
      any_number_of_times.and_return(@lights[2])
  end

  describe "running a test" do
    it "should run a complete test" do
      @test.should_receive(:run_processors)
      @test.should_receive(:report_lights)
      
      @test.run.should == @test
    end
  end

  describe "running processors" do
    it "should run just the first processor" do
      @processors[0].should_receive(:process).with(@test)
      @lights[0].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just the first two processors" do
      @processors[0].should_receive(:process).with(@test)
      @lights[0].should_receive(:green?).and_return(true)
      @processors[1].should_receive(:process).with(@test)
      @lights[1].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just all processors" do
      @processors[0].should_receive(:process).with(@test)
      @lights[0].should_receive(:green?).and_return(true)
      @processors[1].should_receive(:process).with(@test)
      @lights[1].should_receive(:green?).and_return(true)
      @processors[2].should_receive(:process).with(@test)
      @lights[2].should_receive(:green?).and_return(true)
      
      @test.run_processors
    end
  end
  
  describe "reporting lights" do
    it "should report no lights when there are no processors" do
      @test.should_receive(:processors).and_return([])
      
      @test.report_lights
    end
    
    it "should report all lights of processors" do
      @feedback.should_receive(:processor_result).with(@processors[0])
      @feedback.should_receive(:processor_result).with(@processors[1])
      @feedback.should_receive(:processor_result).with(@processors[2])
      
      @test.report_lights
    end
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