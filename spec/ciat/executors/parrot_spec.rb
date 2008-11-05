require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/parrot'

describe CIAT::Executors::Parrot do
  before(:each) do
    @crate = mock('crate')
    @elements = mock('elements')
    @executor = CIAT::Executors::Parrot.new
  end
  
  describe "processing" do
    it "should execute and diff normally" do
      @executor.should_receive(:execute).with(@crate).and_return(true)
      @executor.should_receive(:diff).with(@crate).and_return(true)
      
      @executor.process(@crate).should == @crate
    end

    it "should execute with an error" do
      @executor.should_receive(:execute).with(@crate).and_return(false)
      
      @executor.process(@crate).should == @crate
    end

    it "should execute normally and diff with a failure" do
      @executor.should_receive(:execute).with(@crate).and_return(true)
      @executor.should_receive(:diff).with(@crate).and_return(false)
      
      @executor.process(@crate).should == @crate
    end
  end

  it "should execute generated code" do
    # expect_run(:command_line => nil, :result => true)
    compilation, command_line, execution, result =
      mock("compilation"), mock("command line"), mock("execution"), mock("resut")
    
    @crate.should_receive(:element).with(:compilation, :generated).and_return(compilation)
    compilation.should_receive(:as_file).and_return("compilation file")
    @executor.should_receive(:args).with(@crate).and_return("command line")
    @crate.should_receive(:element).with(:execution, :generated).and_return(execution)
    execution.should_receive(:as_file).and_return("execution file")
    @executor.should_receive(:system).
      with("parrot 'compilation file' command line &> 'execution file'").
      and_return(result)
    
    @executor.execute(@crate).should == result
  end
  
  it "should strip command-line arguments" do
    command_line = mock("command_line")
    
    @crate.should_receive(:element).with(:command_line).and_return(command_line)
    command_line.should_receive(:content).and_return("   argument1 \t argument2  \n\n")
    
    @executor.args(@crate).should == "argument1 \t argument2"
  end
end