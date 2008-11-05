require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/compilers/java'

describe CIAT::Compilers::Java do
  before(:each) do
    @crate = mock('crate')
    @classpath = mock("classpath")
    @compiler_class = mock("compiler class")
    @compiler = CIAT::Compilers::Java.new(@classpath, @compiler_class)
  end
  
  it "should process without error" do
    @compiler.should_receive(:compile).with(@crate).and_return(true)
    @compiler.should_receive(:diff).with(@crate).and_return(true)
    
    @compiler.process(@crate).should == @crate
  end
  
  it "should process with compilation error" do
    @compiler.should_receive(:compile).with(@crate).and_return(false)
    
    @compiler.process(@crate).should == @crate
  end
  
  it "should process with diff failure" do
    @compiler.should_receive(:compile).with(@crate).and_return(true)
    @compiler.should_receive(:diff).with(@crate).and_return(true)
    
    @compiler.process(@crate).should == @crate
  end
  
  it "should compile" do
    source, compilation, error = mock("source"), mock("compilation"), mock("error")
    
    @crate.should_receive(:element).with(:source).at_least(:once).and_return(source)
    source.should_receive(:as_file).and_return("source filename")
    @crate.should_receive(:element).with(:compilation, :generated).at_least(:once).and_return(compilation)
    compilation.should_receive(:as_file).and_return("compilation filename")
    @crate.should_receive(:element).with(:compilation, :error).at_least(:once).and_return(error)
    error.should_receive(:as_file).and_return("error filename")
    @compiler.should_receive(:system).
      with("java -cp '#{@classpath}' #{@compiler_class} 'source filename' 'compilation filename' 2> 'error filename'").
      and_return(true)    
    
    @compiler.compile(@crate).should == true
  end
end