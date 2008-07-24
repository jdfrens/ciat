require File.dirname(__FILE__) + '/spec_helper.rb'

require 'ciat/executor_of_parrot'

describe CIAT::ExecutorOfParrot do
  before(:each) do
    @generated_code_file, @output_file = mock("generated code file"), mock("output file")
    @executor = CIAT::ExecutorOfParrot.new
  end

  it "should run the generated code successfully" do
    expect_run(true)
    @executor.run(@generated_code_file, @output_file).should == true
  end

  it "should run the generated code failurely" do
    expect_run(false)
    @executor.run(@generated_code_file, @output_file).should == false
  end
  
  def expect_run(return_value)
    @executor.should_receive(:system).
      with("parrot '#{@generated_code_file}' &> '#{@output_file}'").
      and_return(return_value)
  end    
end