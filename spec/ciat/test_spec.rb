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
      @test.should_receive(:process).with(@processors[0])
      @lights[0].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just the first two processors" do
      @test.should_receive(:process).with(@processors[0])
      @lights[0].should_receive(:green?).and_return(true)
      @test.should_receive(:process).with(@processors[1])
      @lights[1].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just all processors" do
      @test.should_receive(:process).with(@processors[0])
      @lights[0].should_receive(:green?).and_return(true)
      @test.should_receive(:process).with(@processors[1])
      @lights[1].should_receive(:green?).and_return(true)
      @test.should_receive(:process).with(@processors[2])
      @lights[2].should_receive(:green?).and_return(true)
      
      @test.run_processors
    end
  end
  
  describe "processing a test file" do
    it "should defer to crate and set elements" do
      elements = mock("elements")
      
      @crate.should_receive(:process_test_file).and_return(elements)
      @test.should_receive(:verify_required_elements)
      
      @test.process_test_file
    end
  end

  describe "verifying required elements" do
    it "should verify required elements (no optional elements)" do
      elements = mock("elements")
      requireds = [mock("r 0"), mock("r 1"), mock("r 2")]

      @test.should_receive(:required_elements).and_return(requireds.to_set)
      @test.should_receive(:optional_elements).and_return([].to_set)
      @test.should_receive(:provided_elements).and_return(requireds.to_set)
    
      @test.verify_required_elements
    end
    
    it "should allow optional elements" do
      elements = mock("elements")
      optionals = [mock("o 0"), mock("o 1"), mock("o 2")]
      
      @test.should_receive(:required_elements).and_return([].to_set)
      @test.should_receive(:optional_elements).and_return(optionals.to_set)
      @test.should_receive(:provided_elements).and_return(optionals.to_set)
      
      @test.verify_required_elements
    end
    
    it "should not require optional elements" do
      elements = mock("elements")
      optionals = [mock("o 0"), mock("o 1"), mock("o 2")]
      
      @test.should_receive(:required_elements).and_return([].to_set)
      @test.should_receive(:optional_elements).and_return(optionals.to_set)
      @test.should_receive(:provided_elements).and_return([].to_set)
      
      @test.verify_required_elements
    end
    
    it "should allow some optional elements" do
      elements = mock("elements")
      optionals = [mock("o 0"), mock("o 1"), mock("o 2")]
      provideds = [optionals[0], optionals[2]]
      
      @test.should_receive(:required_elements).and_return([].to_set)
      @test.should_receive(:optional_elements).and_return(optionals.to_set)
      @test.should_receive(:provided_elements).and_return(provideds.to_set)
      
      @test.verify_required_elements
    end
    
    it "should handle required and optional elements" do
      elements = mock("elements")
      requireds = [mock("r 0"), mock("r 1"), mock("r 2")]
      optionals = [mock("o 0"), mock("o 1"), mock("o 2")]
      provideds = requireds + [optionals[0], optionals[2]]
      
      @test.should_receive(:required_elements).and_return(requireds.to_set)
      @test.should_receive(:optional_elements).and_return(optionals.to_set)
      @test.should_receive(:provided_elements).and_return(provideds.to_set)
      
      @test.verify_required_elements      
    end
    
    it "should raise complaint if extra required element" do
      @test.should_receive(:required_elements).and_return([:one, :two, :extra1, :extra2].to_set)
      @test.should_receive(:optional_elements).and_return([])
      @test.should_receive(:provided_elements).and_return([:one, :two].to_set)
      @crate.should_receive(:test_file).and_return("testfile")
      
      lambda { @test.verify_required_elements }.
        should raise_error(RuntimeError, "'extra1', 'extra2' missing from 'testfile'")
    end

    it "should raise complaint if extra required element and some optionals" do
      @test.should_receive(:required_elements).and_return([:one, :two, :extra1].to_set)
      @test.should_receive(:optional_elements).and_return([:a, :b])
      @test.should_receive(:provided_elements).and_return([:one, :two, :a].to_set)
      @crate.should_receive(:test_file).and_return("testfile")
      
      lambda { @test.verify_required_elements }.
        should raise_error(RuntimeError, "'extra1' missing from 'testfile'")
    end

    it "should raise complaint if extra required element, ignoring extra provided" do
      @test.should_receive(:required_elements).and_return([:one, :two, :extra1, :extra2].to_set)
      @test.should_receive(:optional_elements).and_return([])
      @test.should_receive(:provided_elements).and_return([:one, :two, :ignored].to_set)
      @crate.should_receive(:test_file).and_return("testfile")
      
      lambda { @test.verify_required_elements }.
        should raise_error(RuntimeError, "'extra1', 'extra2' missing from 'testfile'")
    end

    it "should raise complaint if extra provided" do
      @test.should_receive(:required_elements).and_return([:one, :two].to_set)
      @test.should_receive(:optional_elements).and_return([].to_set)
      @test.should_receive(:provided_elements).and_return([:one, :two, :extra1, :extra2].to_set)
      @crate.should_receive(:test_file).and_return("testfile")
      
      lambda { @test.verify_required_elements }.
        should raise_error(RuntimeError, "'extra1', 'extra2' from 'testfile' not used")
    end
  end
  
  describe "collecting required elements" do
    it "should get required elements from processors" do
      requireds = [mock("r 0"), mock("r 1"), mock("r 2"), :description]

      @processors[0].should_receive(:required_elements).and_return(requireds[0])
      @processors[1].should_receive(:required_elements).and_return(requireds[1])
      @processors[2].should_receive(:required_elements).and_return(requireds[2])
      
      @test.required_elements.should == requireds.to_set
    end
  end
  
  describe "collected optional elements" do
    it "should get optional elements from processors" do
      optionals = [mock("o 0"), mock("o 1"), mock("o 2")]

      @processors[0].should_receive(:optional_elements).and_return(optionals[0])
      @processors[1].should_receive(:optional_elements).and_return(optionals[1])
      @processors[2].should_receive(:optional_elements).and_return(optionals[2])
      
      @test.optional_elements.should == optionals.to_set
    end
  end
  
  describe "running a processor" do
    before(:each) do
      @processor = @processors[1]
      @light = @lights[1]
    end
    
    it "should compile successfully" do
      @processor.should_receive(:process).with(@crate).and_return(true)
      @test.should_receive(:check).with(@processor)
      
      @test.process(@processor)
    end

    it "should compile for a yellow light with a error" do
      @processor.should_receive(:process).with(@crate).and_return(false)
      @light.should_receive(:yellow!)
      
      @test.process(@processor)
    end
  end
  
  describe "checking a processor's results" do
    before(:each) do
      @processor = @processors[0]
      @light = @lights[0]
    end
    
    it "should be green if no files to check" do
      @processor.should_receive(:checked_files).with(@crate).and_return([])
      @light.should_receive(:red?).and_return(false)
      @light.should_receive(:green!)
      
      @test.check(@processor).should == @light
    end

    it "should be green when diff succeeds" do
      files = [[mock("e 1"), mock("g 1"), mock("d 1")], [mock("e 2"), mock("g 2"), mock("d 2")], [mock("e 3"), mock("g 3"), mock("d 3")]]
      
      @processor.should_receive(:checked_files).with(@crate).and_return(files)
      @differ.should_receive(:diff).with(*files[0]).and_return(true)
      @differ.should_receive(:diff).with(*files[1]).and_return(true)
      @differ.should_receive(:diff).with(*files[2]).and_return(true)
      @light.should_receive(:red?).and_return(false)
      @light.should_receive(:green!)
      
      @test.check(@processor).should == @light
    end

    it "should be red when last diff fails" do
      files = [[mock("e 1"), mock("g 1"), mock("d 1")], [mock("e 2"), mock("g 2"), mock("d 2")], [mock("e 3"), mock("g 3"), mock("d 3")]]
      
      @processor.should_receive(:checked_files).with(@crate).and_return(files)
      @differ.should_receive(:diff).with(*files[0]).and_return(true)
      @differ.should_receive(:diff).with(*files[1]).and_return(true)
      @differ.should_receive(:diff).with(*files[2]).and_return(false)
      @light.should_receive(:red!)
      @light.should_receive(:red?).and_return(true)
      
      @test.check(@processor).should == @light
    end

    it "should be red when first diff fails" do
      files = [[mock("e 1"), mock("g 1"), mock("d 1")], [mock("e 2"), mock("g 2"), mock("d 2")], [mock("e 3"), mock("g 3"), mock("d 3")]]
      
      @processor.should_receive(:checked_files).with(@crate).and_return(files)
      @differ.should_receive(:diff).with(*files[0]).and_return(false)
      @light.should_receive(:red!)
      @differ.should_receive(:diff).with(*files[1]).and_return(true)
      @differ.should_receive(:diff).with(*files[2]).and_return(true)
      @light.should_receive(:red?).and_return(true)
      
      @test.check(@processor).should == @light
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

end
