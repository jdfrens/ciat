require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/compilers/java'

describe CIAT::Compilers::Java do
  before(:each) do
    @crate = mock('crate')
    @classpath = mock("classpath")
    @compiler_class = mock("compiler class")
    @compiler = CIAT::Compilers::Java.new(@classpath, @compiler_class)
  end
  
  describe "describing things" do
    it "should describe itself" do
      @compiler.description.should == "compiler"
    end
    
    it "should have a configurable description" do
      CIAT::Compilers::Java.new(@classpath, @compiler_class, :description => "the description").
        description.should == "the description"
    end
  end

  it "should run the compiler successfully" do
    expect_compile(true)
    @compiler.process(@crate).should == true
  end

  it "should run the compiler failurely" do
    expect_compile(false)
    @compiler.process(@crate).should == false
  end
  
  it "should have files to check" do
    files = mock("filenames")
    
    CIAT::CheckedFile.should_receive(:create).with(@crate, :compilation).and_return(files)
    
    @compiler.checked_files(@crate).should == files
  end
  
  it "should have required elements" do
    @compiler.required_elements.should == [:source, :compilation]
  end
  
  it "should not have an optional elements" do
    @compiler.optional_elements.should == []
  end
  
  def expect_compile(return_value)
    source_file, generated_code_file = mock("source file"), mock("generated code file")
    
    @crate.should_receive(:filename).with(:source).and_return(source_file)
    @crate.should_receive(:filename).with(:compilation, :generated).and_return(generated_code_file)
    @compiler.should_receive(:system).
      with("java -cp '#{@classpath}' #{@compiler_class} '#{source_file}' '#{generated_code_file}'").
      and_return(return_value)
  end    
end