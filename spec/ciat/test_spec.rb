require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @crate = mock("crate")
    @processors = [mock("p 1"), mock("p 2"), mock("p 3")]
    @differ = mock("differ")
    @lights = {
      @processors[0] => mock("light 1"),
      @processors[1] => mock("light 2"),
      @processors[2] => mock("light 3"), 
      }
    @feedback = mock("feedback")
    @test = CIAT::Test.new(@crate,
      :processors => @processors,
      :differ => @differ,
      :lights => @lights,
      :feedback => @feedback)
      
    @elements = mock("elements")
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
      @lights[@processors[0]].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just the first two processors" do
      @test.should_receive(:process).with(@processors[0])
      @lights[@processors[0]].should_receive(:green?).and_return(true)
      @test.should_receive(:process).with(@processors[1])
      @lights[@processors[1]].should_receive(:green?).and_return(false)
      
      @test.run_processors
    end

    it "should run just all processors" do
      @test.should_receive(:process).with(@processors[0])
      @lights[@processors[0]].should_receive(:green?).and_return(true)
      @test.should_receive(:process).with(@processors[1])
      @lights[@processors[1]].should_receive(:green?).and_return(true)
      @test.should_receive(:process).with(@processors[2])
      @lights[@processors[2]].should_receive(:green?).and_return(true)
      
      @test.run_processors
    end
  end
  
  describe "initial setting" do
    it "should have erroring element hash" do
      lambda { @test.elements[:does_not_exist] }.should raise_error("does_not_exist not an expected element")
    end
  end

  describe "processing a test file" do
    it "should defer to crate and set elements" do
      elements = mock("elements")
      @crate.should_receive(:process_test_file).and_return(elements)
      
      @test.process_test_file
      @test.elements.should == elements
    end
  end  
  
  describe "running a processor" do
    before(:each) do
      @processor = @processors[1]
    end
    
    it "should compile successfully" do
      @processor.should_receive(:process).with(@crate).and_return(true)
      @test.should_receive(:check).with(@processor)
      
      @test.process(@processor)
    end

    it "should compile for a yellow light with a error" do
      @processor.should_receive(:process).with(@crate).and_return(false)
      @lights[@processor].should_receive(:yellow!)
      
      @test.process(@processor)
    end
  end
  
  describe "checking a processor's results" do
    before(:each) do
      @processor = @processors[0]
    end
    
    it "should be green if no files to check" do
      @processor.should_receive(:checked_files).with(@crate).and_return([])
      @lights[@processor].should_receive(:red?).and_return(false)
      @lights[@processor].should_receive(:green!)
      
      @test.check(@processor).should == @lights[@processor]
    end

    it "should be green when diff succeeds" do
      files = [[mock("e 1"), mock("g 1"), mock("d 1")], [mock("e 2"), mock("g 2"), mock("d 2")], [mock("e 3"), mock("g 3"), mock("d 3")]]
      
      @processor.should_receive(:checked_files).with(@crate).and_return(files)
      @differ.should_receive(:diff).with(*files[0]).and_return(true)
      @differ.should_receive(:diff).with(*files[1]).and_return(true)
      @differ.should_receive(:diff).with(*files[2]).and_return(true)
      @lights[@processor].should_receive(:red?).and_return(false)
      @lights[@processor].should_receive(:green!)
      
      @test.check(@processor).should == @lights[@processor]
    end

    it "should be red when last diff fails" do
      files = [[mock("e 1"), mock("g 1"), mock("d 1")], [mock("e 2"), mock("g 2"), mock("d 2")], [mock("e 3"), mock("g 3"), mock("d 3")]]
      
      @processor.should_receive(:checked_files).with(@crate).and_return(files)
      @differ.should_receive(:diff).with(*files[0]).and_return(true)
      @differ.should_receive(:diff).with(*files[1]).and_return(true)
      @differ.should_receive(:diff).with(*files[2]).and_return(false)
      @lights[@processor].should_receive(:red!)
      @lights[@processor].should_receive(:red?).and_return(true)
      
      @test.check(@processor).should == @lights[@processor]
    end

    it "should be red when first diff fails" do
      files = [[mock("e 1"), mock("g 1"), mock("d 1")], [mock("e 2"), mock("g 2"), mock("d 2")], [mock("e 3"), mock("g 3"), mock("d 3")]]
      
      @processor.should_receive(:checked_files).with(@crate).and_return(files)
      @differ.should_receive(:diff).with(*files[0]).and_return(false)
      @lights[@processor].should_receive(:red!)
      @differ.should_receive(:diff).with(*files[1]).and_return(true)
      @differ.should_receive(:diff).with(*files[2]).and_return(true)
      @lights[@processor].should_receive(:red?).and_return(true)
      
      @test.check(@processor).should == @lights[@processor]
    end
  end
  
  describe "reporting lights" do
    it "should report no lights when there are no processors" do
      @test.should_receive(:processors).and_return([])
      
      @test.report_lights
    end
    
    it "should report all lights of processors" do
      @feedback.should_receive(:processor_result).with(@processors[0], @lights[@processors[0]])
      @feedback.should_receive(:processor_result).with(@processors[1], @lights[@processors[1]])
      @feedback.should_receive(:processor_result).with(@processors[2], @lights[@processors[2]])
      
      @test.report_lights
    end
  end

end
