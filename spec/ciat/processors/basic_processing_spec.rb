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
      @light = mock("light")
      @processor.should_receive(:light).any_number_of_times.and_return(@light)
    end
    
    it "should execute and diff normally" do
      @processor.should_receive(:execute).with(@test).and_return(true)
      @processor.should_receive(:diff).with(@test).and_return(true)
      @light.should_receive(:green!)
      
      @processor.process(@test).should == @test
    end

    it "should execute with an error" do
      @processor.should_receive(:execute).with(@test).and_return(false)
      @light.should_receive(:yellow!)
      
      @processor.process(@test).should == @test
    end

    it "should execute normally and diff with a failure" do
      @processor.should_receive(:execute).with(@test).and_return(true)
      @processor.should_receive(:diff).with(@test).and_return(false)
      @light.should_receive(:red!)
      
      @processor.process(@test).should == @test
    end
  end
  
  describe "executing a processor for a test" do
    it "should put together and execute a shell command" do
      test, result = mock("test"), mock("result")
      
      @processor.should_receive(:executable).and_return("[executable]")
      @processor.should_receive(:input_file).with(test).
        and_return("[input]")
      @processor.should_receive(:command_line_args).with(test).
        and_return("[args]")
      @processor.should_receive(:output_file).with(test).
        and_return("[output]")
      @processor.should_receive(:error_file).with(test).
        and_return("[error]") 
      @processor.should_receive(:system).
        with("[executable] '[input]' [args] > '[output]' 2> '[error]'").
        and_return(result)
      
      @processor.execute(test).should eql(result)
    end
  end

  it "should look up relevant elements" do
    test = mock("test")
    names = [mock("name 0"), mock("name 1"), mock("name 2")]
    elements = [mock("element 0"), mock("element 1"), mock("element 2")]
    
    @processor.should_receive(:relevant_element_names).and_return(names)
    test.should_receive(:element?).with(names[0]).and_return(true)
    test.should_receive(:element).with(names[0]).and_return(elements[0])
    test.should_receive(:element?).with(names[1]).and_return(true)
    test.should_receive(:element).with(names[1]).and_return(elements[1])
    test.should_receive(:element?).with(names[2]).and_return(true)
    test.should_receive(:element).with(names[2]).and_return(elements[2])
    
    @processor.relevant_elements(test).should == elements
  end

  it "should look up only provided, relevant elements" do
    test = mock("test")
    names = [mock("name 0"), mock("name 1"), mock("name 2")]
    elements = [mock("element 0"), mock("element 2")]
    
    @processor.should_receive(:relevant_element_names).and_return(names)
    test.should_receive(:element?).with(names[0]).and_return(true)
    test.should_receive(:element).with(names[0]).and_return(elements[0])
    test.should_receive(:element?).with(names[1]).and_return(false)
    test.should_receive(:element?).with(names[2]).and_return(true)
    test.should_receive(:element).with(names[2]).and_return(elements[1])
    
    @processor.relevant_elements(test).should == elements
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
  
  it "should have relevant element names" do
    kind, hash, light, setting = 
      mock("kind"), mock("hash"), mock("light"), mock("setting")
    names = mock("names")
    
    @processor.should_receive(:kind).and_return(kind)
    kind.should_receive(:element_name_hash).and_return(hash)
    @processor.should_receive(:light).and_return(light)
    light.should_receive(:setting).and_return(setting)
    hash.should_receive(:[]).with(setting).and_return(names)
    
    @processor.relevant_element_names.should eql(names)
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
