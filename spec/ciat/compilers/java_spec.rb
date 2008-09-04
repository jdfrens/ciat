require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/compilers/java'

describe CIAT::Compilers::Java do
  before(:each) do
    @crate = mock('crate')
    @classpath = mock("classpath")
    @compiler_class = mock("compiler class")
    @compiler = CIAT::Compilers::Java.new(@classpath, @compiler_class)
  end

  it "should run the compiler successfully" do
    expect_compile(true)
    @compiler.process(@crate).should == true
  end

  it "should run the compiler failurely" do
    expect_compile(false)
    @compiler.process(@crate).should == false
  end
  
  def expect_compile(return_value)
    source_file, generated_code_file = mock("source file"), mock("generated code file")
    
    @crate.should_receive(:source).and_return(source_file)
    @crate.should_receive(:compilation_generated).and_return(generated_code_file)
    @compiler.should_receive(:system).
      with("java -cp '#{@classpath}' #{@compiler_class} '#{source_file}' '#{generated_code_file}'").
      and_return(return_value)
  end    
end