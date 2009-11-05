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
      @subtests = array_of_mocks(3, "subtests")
      @test.should_receive(:make_subtests).and_return(@subtests)
      @subresults = array_of_mocks(3, "subresult")
    end
    
    it "should run just the first processor" do
      expect_not_green(@subtests[0], @subresults[0])
      expect_unset(@subtests[1], @subresults[1])
      expect_unset(@subtests[2], @subresults[2])
      
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
      light = mock("light", :green? => true)
      subtest.should_receive(:process).with(@ciat_file).and_return(light)
      @test.should_receive(:subresult).with(subtest, light).
        and_return(subresult)
      subresult.should_receive(:light).and_return(light)
    end
    
    def expect_not_green(subtest, subresult)
      light = mock("light", :green? => false)
      subtest.should_receive(:process).with(@ciat_file).and_return(light)
      @test.should_receive(:subresult).with(subtest, light).
        and_return(subresult)
      subresult.should_receive(:light).and_return(light)
    end
    
    def expect_unset(subtest, subresult)
      @test.should_receive(:subresult).with(subtest).and_return(subresult)
    end
  end
  
  it "should build and report subresult" do
    path_kind, light, processor = 
      mock("path kind"), mock("light"), mock("processor")
    subresult = mock("subresult")
    
    processor.should_receive(:path_kind).
      with(@ciat_file).and_return(path_kind)
    CIAT::Subresult.should_receive(:new).
      with(@ciat_file, path_kind, light, processor).and_return(subresult)
    @feedback.should_receive(:report_subresult).with(subresult)

    @test.subresult(processor, light).should == subresult
  end
end