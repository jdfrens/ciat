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
  
  it "should have files to check" do
    checked_files = [mock('expected'), mock('generated'), mock('diff')]
    @crate.should_receive(:filename).with(:execution).and_return(checked_files[0])
    @crate.should_receive(:filename).with(:execution, :generated).and_return(checked_files[1])
    @crate.should_receive(:filename).with(:execution, :diff).and_return(checked_files[2])    
    
    @executor.checked_files(@crate).should == [checked_files]
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