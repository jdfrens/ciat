require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/java'

describe CIAT::Executors::Java do
  describe "mixins" do
    it "should use basic processing module" do
      CIAT::Executors::Java.should include(CIAT::Processors::BasicProcessing)
    end
  end
  
  before(:each) do
    @classpath = mock("classpath", :to_s => 'the classpath')
    @interpreter_class = mock("interpreter", :to_s => 'the interpreter')
    @crate = mock('crate')
    @elements = mock('elements')
    @executor = CIAT::Executors::Java.new(@classpath, @interpreter_class)
  end
  
  describe "processing" do
    it "should execute and diff normally" do
      @executor.should_receive(:execute).with(@crate).and_return(true)
      @executor.should_receive(:diff).with(@crate).and_return(true)
      
      @executor.process(@crate).should == @crate
      @executor.light.should be_green
    end

    it "should execute with an error" do
      @executor.should_receive(:execute).with(@crate).and_return(false)
      
      @executor.process(@crate).should == @crate
      @executor.light.should be_yellow
    end

    it "should execute normally and diff with a failure" do
      @executor.should_receive(:execute).with(@crate).and_return(true)
      @executor.should_receive(:diff).with(@crate).and_return(false)
      
      @executor.process(@crate).should == @crate
      @executor.light.should be_red
    end
  end

  it "should have an executable" do
    @executor.executable.should == "java -cp 'the classpath' the interpreter"
  end
  
end
