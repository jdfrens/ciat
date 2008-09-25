require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/parrot'

describe CIAT::Executors::Parrot do
  before(:each) do
    @crate = mock('crate')
    @executor = CIAT::Executors::Parrot.new
  end

  it "should run the generated code successfully" do
    expect_run(true)
    @executor.process(@crate).should == true
  end

  it "should run the generated code failurely" do
    expect_run(false)
    @executor.process(@crate).should == false
  end
  
  it "should required elements" do
    @executor.required_elements.should == [:execution]
  end
  
  it "should have files to check" do
    filenames = mock("filenames")
    
    @crate.should_receive(:diff_filenames).with(:execution).and_return(filenames)    
    
    @executor.checked_files(@crate).should == [filenames]
  end
  
  def expect_run(return_value)
    generated_code_file, output_file = mock("generated code file"), mock("output file")
    
    @crate.should_receive(:filename).with(:compilation, :generated).and_return(generated_code_file)
    @crate.should_receive(:filename).with(:execution, :generated).and_return(output_file)
    @executor.should_receive(:system).
      with("parrot '#{generated_code_file}' &> '#{output_file}'").
      and_return(return_value)
  end    
end