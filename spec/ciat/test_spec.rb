require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @crate = mock("crate")
    @processors = [mock("p 0"), mock("p 1"), mock("p 2")]
    @differ = mock("differ")
    @lights = [mock("light 0"), mock("light 1"), mock("light 2")]
    @feedback = mock("feedback")
    @test = CIAT::Test.new(@crate,
      :processors => @processors,
      :differ => @differ,
      :feedback => @feedback)
    @processors[0].should_receive(:light).any_number_of_times.and_return(@lights[0])
    @processors[1].should_receive(:light).any_number_of_times.and_return(@lights[1])
    @processors[2].should_receive(:light).any_number_of_times.and_return(@lights[2])
  end

  describe "running a test" do
    it "should run a complete test" do
      @test.should_receive(:process_test_file)
      @test.should_receive(:run_processors)
      @test.should_receive(:report_lights)
      
      @test.run.should == @test
    end
  end

  describe "running processors" do
    it "should run just the first processor" do
      @processors[0].should_receive(:process).with(@test)
      @lights[0].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just the first two processors" do
      @processors[0].should_receive(:process).with(@test)
      @lights[0].should_receive(:green?).and_return(true)
      @processors[1].should_receive(:process).with(@test)
      @lights[1].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just all processors" do
      @processors[0].should_receive(:process).with(@test)
      @lights[0].should_receive(:green?).and_return(true)
      @processors[1].should_receive(:process).with(@test)
      @lights[1].should_receive(:green?).and_return(true)
      @processors[2].should_receive(:process).with(@test)
      @lights[2].should_receive(:green?).and_return(true)
      
      @test.run_processors
    end
  end
  
  describe "reporting lights" do
    it "should report no lights when there are no processors" do
      @test.should_receive(:processors).and_return([])
      
      @test.report_lights
    end
    
    it "should report all lights of processors" do
      @feedback.should_receive(:processor_result).with(@processors[0])
      @feedback.should_receive(:processor_result).with(@processors[1])
      @feedback.should_receive(:processor_result).with(@processors[2])
      
      @test.report_lights
    end
  end

  describe "processing test file" do
    it "should split and write" do
      raw_elements = { :e0 => mock("raw element 0"), :e1 => mock("raw element 1"), :e2 => mock("raw element 2")}
      filenames = [mock("filename 0"), mock("filename 1"), mock("filename 2")]
      elements = { :e0 => mock("element 0"), :e1 => mock("element 1"), :e2 => mock("element 2")}

      @test.should_receive(:split_test_file).and_return(raw_elements)
      @crate.should_receive(:filename).with(:e0).and_return(filenames[0])
      @crate.should_receive(:filename).with(:e1).and_return(filenames[1])
      @crate.should_receive(:filename).with(:e2).and_return(filenames[2])
      CIAT::TestElement.should_receive(:new).with(:e0, filenames[0], raw_elements[:e0]).and_return(elements[:e0])
      CIAT::TestElement.should_receive(:new).with(:e1, filenames[1], raw_elements[:e1]).and_return(elements[:e1])
      CIAT::TestElement.should_receive(:new).with(:e2, filenames[2], raw_elements[:e2]).and_return(elements[:e2])
      
      @test.process_test_file.should == elements
    end
  end
  
  describe "splitting a test file" do
    before(:each) do
      @filename = mock("filename")
    end

    it "should split just a description" do
      expect_file_content("description only\n")
      @test.split_test_file.should == { :description => "description only\n" }
    end
    
    it "should split description and something else" do
      expect_file_content("description\n", "==== tag\n", "content\n")
      @test.split_test_file.should == { :description => "description\n", :tag => "content\n" }
    end
    
    it "should split the test file" do
      expect_file_content("d\n", "==== source\n", "s\n",
        "==== compilation_expected \n", "p\n",
        "==== output_expected\n", "o\n")
      @test.split_test_file.should == { :description => "d\n",
        :source => "s\n", :compilation_expected => "p\n", :output_expected => "o\n" }
    end
    
    it "should allow spaces in element name" do
      expect_file_content("description\n" , "==== element name\n", "content\n")
      @test.split_test_file.should == {
        :description => "description\n", :element_name => "content\n" }
    end
    
    def expect_file_content(*content)
      @crate.should_receive(:read_test_file).and_return(content)
    end
  end

  describe "processing elements" do
    before(:each) do
      @elements = mock("elements")
      @test.should_receive(:elements).and_return(@elements)
    end
    
    it "should return specified element" do
      element = mock("element")
    
      @elements.should_receive(:[]).with(:foo).and_return(element)
    
      @test.element(:foo).should == element
    end

    it "should return specified element with multi-word name" do
      element = mock("element")
    
      @elements.should_receive(:[]).with(:foo_bar_joe).and_return(element)
    
      @test.element(:foo, :bar, :joe).should == element
    end
  
    it "should check to see if element exists" do
      exists = mock("a boolean")
    
      @elements.should_receive(:has_key?).with(:foo_bar_joe).and_return(exists)
    
      @test.element?(:foo, :bar, :joe).should == exists
    end
  end
end