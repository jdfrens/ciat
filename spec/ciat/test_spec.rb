require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  include MockHelpers
  
  before(:each) do
    @filename = mock("filename")
    @ciat_file = mock("ciat file")
    @processors = [mock("p 0"), mock("p 1"), mock("p 2")]
    @differ = mock("differ")
    @feedback = mock("feedback")
    @test = CIAT::Test.new(@ciat_file, @processors, @feedback)
  end

  describe "running a test" do
    it "should run a complete test" do
      subresults = mock("subresults")
      result = mock("result")
      
      @test.should_receive(:run_subtests).and_return(subresults)
      CIAT::TestResult.should_receive(:new).with(@ciat_file, subresults).
        and_return(result)
      
      @test.run.should == result
    end
  end
  
  describe "running processors" do
    before(:each) do
      @subtests = array_of_mocks(3, "subtest")
      @test.should_receive(:make_subtests).and_return(@subtests)
      @subresults = array_of_mocks(3, "subresult")
    end
    
    it "should run just the first processor because of a non-green subtest" do
      expect_not_green(@subtests[0], @subresults[0])
      expect_unset(@subtests[1], @subresults[1])
      expect_unset(@subtests[2], @subresults[2])
      
      @test.run_subtests.should == @subresults
    end
    
    it "should run just the first processor because of a sad subtest" do
      expect_green(@subtests[0], @subresults[0])
      expect_sad(@subtests[1], @subresults[1])
      expect_unneeded(@subtests[2], @subresults[2])
      
      @test.run_subtests.should == @subresults
    end
    
    it "should run just the first two processors" do
      expect_green(@subtests[0], @subresults[0])
      expect_not_green(@subtests[1], @subresults[1])
      expect_unset(@subtests[2], @subresults[2])
      
      @test.run_subtests.should == @subresults
    end

    it "should run all processors" do
      expect_green(@subtests[0], @subresults[0])
      expect_green(@subtests[1], @subresults[1])
      expect_green(@subtests[2], @subresults[2])
            
      @test.run_subtests.should == @subresults
    end

    def expect_green(subtest, subresult)
      subtest.stub!(:sad_path?).and_return(false)
      light = mock("light", :green? => true)
      subtest.should_receive(:process).with().and_return(light)
      @test.should_receive(:subresult).with(subtest, light).
        and_return(subresult)
      subresult.should_receive(:light).and_return(light)
    end
    
    def expect_sad(subtest, subresult)
      light = mock("light")
      subtest.should_receive(:process).with().and_return(light)
      @test.should_receive(:subresult).with(subtest, light).
        and_return(subresult)
      subresult.stub!(:light).and_return(light)
      subtest.should_receive(:sad_path?).and_return(true)
    end
    
    def expect_not_green(subtest, subresult)
      subtest.stub!(:sad_path?).and_return(false)
      light = mock("light", :green? => false)
      subtest.should_receive(:process).with().and_return(light)
      @test.should_receive(:subresult).with(subtest, light).
        and_return(subresult)
      subresult.should_receive(:light).and_return(light)
    end
    
    def expect_unset(subtest, subresult)
      @test.should_receive(:subresult).
        with(subtest, CIAT::TrafficLight::UNSET).and_return(subresult)
    end
    
    def expect_unneeded(subtest, subresult)
      @test.should_receive(:subresult).
        with(subtest, CIAT::TrafficLight::UNNEEDED).and_return(subresult)
    end
  end
  
  it "should build and report subresult" do
    path_kind, light, subtest = 
      mock("path kind"), mock("light"), mock("subtest")
    subresult = mock("subresult")
    
    subtest.should_receive(:path_kind).and_return(path_kind)
    CIAT::Subresult.should_receive(:new).
      with(@ciat_file, path_kind, light, subtest).and_return(subresult)
    @feedback.should_receive(:report_subresult).with(subresult)

    @test.subresult(subtest, light).should == subresult
  end
end