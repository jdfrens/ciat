require File.dirname(__FILE__) + '/../../spec_helper'

describe CIAT::Processors::BasicProcessing do
  class Processor
    include CIAT::Processors::BasicProcessing
  end
  
  before(:each) do
    @processor = Processor.new
  end
  
  describe "processing" do
    before(:each) do
      @test = mock("test")
    end
    
    it "should execute and diff normally" do
      @processor.should_receive(:execute).with(@test).and_return(true)
      @processor.should_receive(:diff).with(@test).and_return(true)
      
      @processor.process(@test).should == CIAT::TrafficLight::GREEN
    end

    it "should execute with an error" do
      @processor.should_receive(:execute).with(@test).and_return(false)
      
      @processor.process(@test).should == CIAT::TrafficLight::YELLOW
    end

    it "should execute normally and diff with a failure" do
      @processor.should_receive(:execute).with(@test).and_return(true)
      @processor.should_receive(:diff).with(@test).and_return(false)
      
      @processor.process(@test).should == CIAT::TrafficLight::RED
    end
  end
  
  describe "executing a processor for a test" do
    it "should put together and execute a shell command" do
      test, ok, result = mock("test"), mock("ok"), mock("result")
      
      @processor.should_receive(:executable).and_return("[executable]")
      @processor.should_receive(:input_file).with(test).
        and_return("[input]")
      @processor.should_receive(:command_line_args).with(test).
        and_return("[args]")
      @processor.should_receive(:output_file).with(test).
        and_return("[output]")
      @processor.should_receive(:error_file).with(test).
        and_return("[error]") 
      @processor.should_receive(:sh).
        with("[executable] '[input]' [args] > '[output]' 2> '[error]'").
        and_yield(ok, result)
      
      @processor.execute(test).should == ok
    end
  end
  
  describe "handling command-line arguments" do
    it "should strip command-line arguments" do
      test = mock("test")
      command_line = mock("command_line")
    
      test.should_receive(:element?).with(:command_line).and_return(true)
      test.should_receive(:element).with(:command_line).
        and_return(command_line)
      command_line.should_receive(:content).
        and_return("   argument1 \t argument2  \n\n")
    
      @processor.command_line_args(test).should == "argument1 \t argument2"
    end
    
    it "should return empty string if none provided" do
      test = mock("test")
      
      test.should_receive(:element?).with(:command_line).and_return(false)
      
      @processor.command_line_args(test).should == ''
    end
  end
  
  describe "computing a diff" do
    it "should compute a diff in HTML" do
      test, kind, result = 
        mock("test"), mock("processor kind"), mock("result")
      output_name = mock("output name")

      @processor.should_receive(:kind).any_number_of_times.and_return(kind)
      kind.should_receive(:output_name).any_number_of_times.
        and_return(output_name)
      original_file = expect_element_as_file(test, output_name)
      generated_file = expect_element_as_file(test, output_name, :generated)
      diff_file = expect_element_as_file(test, output_name, :diff)
      @processor.should_receive(:html_diff).
        with(original_file, generated_file, diff_file).and_return(result)
    
      @processor.diff(test).should eql(result)
    end
    
    def expect_element_as_file(test, *names)
      element, filename = mock("#{names} element"), mock("#{names} filename")
      test.should_receive(:element).with(*names).and_return(element)
      element.should_receive(:as_file).and_return(filename)
      filename
    end
  end
  
  it "should get filename of input" do
    test = mock("test")
    kind, element, name = mock("kind"), mock("element"), mock("name")
    filename = mock("filename")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:input_name).and_return(name)
    test.should_receive(:element).with(name).and_return(element)
    element.should_receive(:as_file).and_return(filename)
    
    @processor.input_file(test).should eql(filename)
  end

  it "should get filename of input" do
    test = mock("test")
    kind, element, name = mock("kind"), mock("element"), mock("name")
    filename = mock("filename")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:output_name).and_return(name)
    test.should_receive(:element).with(name, :generated).and_return(element)
    element.should_receive(:as_file).and_return(filename)
    
    @processor.output_file(test).should eql(filename)
  end

  it "should get filename of input" do
    test = mock("test")
    kind, element, name = mock("kind"), mock("element"), mock("name")
    filename = mock("filename")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:output_name).and_return(name)
    test.should_receive(:element).with(name, :error).and_return(element)
    element.should_receive(:as_file).and_return(filename)
    
    @processor.error_file(test).should eql(filename)
  end
end
