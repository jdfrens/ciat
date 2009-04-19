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
    @compiler.light.should be_green
  end
  
  it "should process with compilation error" do
    @compiler.should_receive(:compile).with(@crate).and_return(false)
    
    @compiler.process(@crate).should == @crate
    @compiler.light.should be_yellow
  end
  
  it "should process with diff failure" do
    @compiler.should_receive(:compile).with(@crate).and_return(true)
    @compiler.should_receive(:diff).with(@crate).and_return(false)
    
    @compiler.process(@crate).should == @crate
    @compiler.light.should be_red
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

describe "returning the relevant elements" do
  before(:each) do
    @light = CIAT::TrafficLight.new
    @compiler = CIAT::Compilers::Java.new(@classpath, @compiler_class, :light => @light)
  end
  
  it "should return the relevant names mapped to elements" do
    crate = mock("crate")
    names = [mock("name 1"), mock("name 2"), mock("name 3")]
    elements = [mock("element 1"), mock("element 2"), mock("element 3")]
    
    @compiler.should_receive(:relevant_names).and_return(names)
    crate.should_receive(:element).with(names[0]).and_return(elements[0])
    crate.should_receive(:element).with(names[1]).and_return(elements[1])
    crate.should_receive(:element).with(names[2]).and_return(elements[2])

    @compiler.relevant_elements(crate).should == elements
  end
  
  it "should return source and compilation on a green light" do
    @light.green!

    @compiler.relevant_names.should == [:source, :compilation]
  end

  it "should return source and error output on a yellow light" do
    @light.yellow!

    @compiler.relevant_names.should == [:source, :compilation_error]
  end
  
  it "should return source and diff on a red light" do
    @light.red!

    @compiler.relevant_names.should == [:source, :compilation_diff]
  end
end
