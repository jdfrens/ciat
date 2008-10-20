require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/parrot'

describe CIAT::Executors::Parrot do
  before(:each) do
    @crate = mock('crate')
    @elements = mock('elements')
    @executor = CIAT::Executors::Parrot.new
  end

  describe "running a test" do
    it "should run the generated code successfully without command-line arguments" do
      expect_run(:command_line => nil, :result => true)
      @executor.process(@crate).should == true
    end

    it "should run the generated code successfully with command-line arguments" do
      expect_run(:command_line => "arg", :result => true)
      @executor.process(@crate).should == true
    end

    it "should run the generated code failurely without command-line arguments" do
      expect_run(:command_line => nil, :result => false)
      @executor.process(@crate).should == false
    end
  
    it "should run the generated code failurely with command-line arguments" do
      expect_run(:command_line => "args", :result => false)
      @executor.process(@crate).should == false
    end
  
    it "should strip the command-line arguments" do
      expect_run(:command_line => "arg\n\n", :result => true)
      @executor.process(@crate).should == true
    end

    def expect_run(options)
      command_line = options[:command_line] || ''
      return_value = options[:result]
      generated_code_file, output_file = mock("generated code file"), mock("output file")
    
      @crate.should_receive(:element).with(:command_line).and_return(command_line)
      @crate.should_receive(:filename).with(:compilation, :generated).and_return(generated_code_file)
      @crate.should_receive(:filename).with(:execution, :generated).and_return(output_file)
      @executor.should_receive(:system).
        with("parrot '#{generated_code_file}' #{command_line.strip} &> '#{output_file}'").
        and_return(return_value)
    end    
  end

  it "should have required elements" do
    @executor.required_elements.should == [:execution]
  end
  
  it "should have optional elements" do
    @executor.optional_elements.should == [:command_line]
  end
  
  it "should have files to check" do
    filenames = mock("filenames")
    
    @crate.should_receive(:diff_filenames).with(:execution).and_return(filenames)    
    
    @executor.checked_files(@crate).should == [filenames]
  end
  
  describe "providing descriptions" do
    it "should have a default description" do
      @executor.description.should == "Parrot virtual machine"
    end
    
    it "should have a settable description" do
      CIAT::Executors::Parrot.new(:description => 'new description').description.should == 'new description'
    end
    
    it "should have a description for command-line arguments" do
      @executor.description(:command_line).should == "Command-line arguments"
    end
  end
end