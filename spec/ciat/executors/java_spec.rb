require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/java'

describe CIAT::Executors::Java do
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

  it "should execute generated code" do
    source, command_line, execution, error, result =
      mock("source"), mock("command line"), mock("execution"), mock("error"), mock("resut")
    
    @crate.should_receive(:element).with(:source).and_return(source)
    source.should_receive(:as_file).and_return("source file")
    @crate.should_receive(:element).with(:execution, :generated).and_return(execution)
    execution.should_receive(:as_file).and_return("execution file")
    @executor.should_receive(:system).
      with("java -cp 'the classpath' the interpreter 'source file' &> 'execution file'").
      and_return(result)
    
    @executor.execute(@crate).should == result
  end
  
  describe "elements of Java interpreter" do
    it "should produce compilation and execution" do
      source, execution = mock("source"), mock("execution")
      
      @crate.should_receive(:element?).
        with(anything()).
        any_number_of_times.and_return(true)
      @crate.should_receive(:element).
        with(:source).and_return(source)
      @crate.should_receive(:element).
        with(:execution_generated).and_return(execution)
      
      @executor.elements(@crate).should == [source, execution]
    end
  end
end