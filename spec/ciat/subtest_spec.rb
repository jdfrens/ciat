require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::Subtest do
  before(:each) do
    @ciat_file = mock("ciat file")
    @processor = mock("processor")
    @subtest = CIAT::Subtest.new(@ciat_file, @processor)
  end
  
  describe "processing" do
    it "should execute and diff normally" do
      @subtest.should_receive(:execute).with().and_return(true)
      @subtest.should_receive(:diff).with().and_return(true)
      
      @subtest.process.should == CIAT::TrafficLight::GREEN
    end

    it "should execute with an error" do
      @subtest.should_receive(:execute).with().and_return(false)
      
      @subtest.process.should == CIAT::TrafficLight::YELLOW
    end

    it "should execute normally and diff with a failure" do
      @subtest.should_receive(:execute).with().and_return(true)
      @subtest.should_receive(:diff).with().and_return(false)
      
      @subtest.process.should == CIAT::TrafficLight::RED
    end
  end
  
  it "should determine a happy path" do
    result = mock("result")
    
    @processor.stub_chain(:kind, :happy_path_element).and_return(:foobar)
    @ciat_file.should_receive(:element?).with(:foobar).and_return(result)
    
    @subtest.happy_path?.should == result
  end
  
  describe "path kind" do
    it "should indicate happy path as path kind" do
      @subtest.should_receive(:happy_path?).with().and_return(true)
    
      @subtest.path_kind.should == :happy
    end

    it "should indicate sad path as path kind" do
      @subtest.should_receive(:happy_path?).with().and_return(false)
    
      @subtest.path_kind.should == :sad
    end
  end
  
  describe "executing a processor for a test" do
    it "should run successful command line for happy path" do
      kind =  mock("kind")
      result = mock("result")
      
      @subtest.should_receive(:command_line).and_return("[command line]")
      @subtest.should_receive(:happy_path?).with().and_return(true)
      @subtest.should_receive(:sh).with("[command line]").
        and_yield(true, result)
      
      @subtest.execute.should be_true
    end
    
    it "should run erroring command line for happy path" do
      test, kind = mock("test"), mock("kind")
      result = mock("result")
      
      @subtest.should_receive(:command_line).and_return("[command line]")
      @subtest.should_receive(:happy_path?).with().and_return(true)
      @subtest.should_receive(:sh).with("[command line]").
        and_yield(false, result)
      
      @subtest.execute.should be_false
    end
    
    it "should prepare a command line" do
      test = mock("test")
      
      @processor.should_receive(:executable).and_return("[executable]")
      @subtest.should_receive(:input_file).with().
        and_return("[input]")
      @subtest.should_receive(:command_line_args).with().
        and_return("[args]")
      @subtest.should_receive(:output_file).with().
        and_return("[output]")
      @subtest.should_receive(:error_file).with().
        and_return("[error]") 
        
      @subtest.command_line.should ==
        "[executable] '[input]' [args] > '[output]' 2> '[error]'"
    end
  end
  
  describe "handling command-line arguments" do
    it "should strip command-line arguments" do
      command_line = mock("command_line")
    
      @ciat_file.should_receive(:element?).with(:command_line).
        and_return(true)
      @ciat_file.should_receive(:element).with(:command_line).
        and_return(command_line)
      command_line.should_receive(:content).
        and_return("   argument1 \t argument2  \n\n")
    
      @subtest.command_line_args.should == "argument1 \t argument2"
    end
    
    it "should return empty string if none provided" do   
      @ciat_file.should_receive(:element?).
        with(:command_line).and_return(false)
      
      @subtest.command_line_args.should == ''
    end
  end
  
  describe "computing a diff" do
    it "should compute a diff in HTML for normal output" do
      kind, result = mock("processor kind"), mock("result")
      output_name = mock("output name")

      @subtest.should_receive(:happy_path?).with().and_return(true)
      @processor.should_receive(:kind).any_number_of_times.and_return(kind)
      kind.should_receive(:output_name).any_number_of_times.
        and_return(output_name)
      original_file = expect_element_as_file(output_name)
      generated_file = expect_element_as_file(output_name, :generated)
      diff_file = expect_element_as_file(output_name, :diff)
      @subtest.should_receive(:html_diff).
        with(original_file, generated_file, diff_file).and_return(result)
    
      @subtest.diff.should == result
    end

    it "should compute a diff in HTML for error output" do
      kind, result = mock("processor kind"), mock("result")
      error_name = mock("error name")

      @subtest.should_receive(:happy_path?).with().and_return(false)
      @processor.should_receive(:kind).any_number_of_times.and_return(kind)
      kind.should_receive(:error_name).any_number_of_times.
        and_return(error_name)
      original_file = expect_element_as_file(error_name)
      generated_file = expect_element_as_file(error_name, :generated)
      diff_file = expect_element_as_file(error_name, :diff)
      @subtest.should_receive(:html_diff).
        with(original_file, generated_file, diff_file).and_return(result)
    
      @subtest.diff.should == result
    end
    
    def expect_element_as_file(*names)
      element, filename = mock("#{names} element"), mock("#{names} filename")
      @ciat_file.should_receive(:element).with(*names).and_return(element)
      element.should_receive(:as_file).and_return(filename)
      filename
    end
  end
  
  it "should get filename of input" do
    kind, element, name = mock("kind"), mock("element"), mock("name")
    filename = mock("filename")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:input_name).and_return(name)
    @ciat_file.should_receive(:element).with(name).and_return(element)
    element.should_receive(:as_file).and_return(filename)
    
    @subtest.input_file.should == filename
  end

  it "should get filename of output" do
    kind, element, name = mock("kind"), mock("element"), mock("name")
    filename = mock("filename")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:output_name).and_return(name)
    @ciat_file.should_receive(:element).with(name, :generated).and_return(element)
    element.should_receive(:as_file).and_return(filename)
    
    @subtest.output_file.should == filename
  end

  it "should get filename of error" do
    kind, element, name = mock("kind"), mock("element"), mock("name")
    filename = mock("filename")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:error_name).and_return(name)
    @ciat_file.should_receive(:element).
      with(name, :generated).and_return(element)
    element.should_receive(:as_file).and_return(filename)
    
    @subtest.error_file.should == filename
  end
end
