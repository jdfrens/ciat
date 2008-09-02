require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/compilers/java'

describe CIAT::Compilers::Java do
  before(:each) do
    @source_file, @generated_code_file = mock("source file"), mock("generated code file")
    @classpath = mock("classpath")
    @compiler_class = mock("compiler class")
    @compiler = CIAT::Compilers::Java.new(@classpath, @compiler_class)
  end

  it "should run the compiler successfully" do
    expect_compile(true)
    @compiler.process(@source_file, @generated_code_file).should == true
  end

  it "should run the compiler failurely" do
    expect_compile(false)
    @compiler.process(@source_file, @generated_code_file).should == false
  end
  
  def expect_compile(return_value)
    @compiler.should_receive(:system).
      with("java -cp '#{@classpath}' #{@compiler_class} '#{@source_file}' '#{@generated_code_file}'").
      and_return(return_value)
  end    
end