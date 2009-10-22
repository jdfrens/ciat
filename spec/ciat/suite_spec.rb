require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Suite do
  before(:each) do
    @processors = mock("processors")
    @feedback = mock("feedback")
  end
  
  it "should construct with suite builder" do
    options = mock("options")
    suite_builder = mock("suite builder")
    
    CIAT::SuiteBuilder.should_receive(:new).
      with(options).and_return(suite_builder)
    suite_builder.should_receive(:build_processors)
    suite_builder.should_receive(:build_output_folder)
    suite_builder.should_receive(:build_test_files)
    suite_builder.should_receive(:build_feedback)
      
    CIAT::Suite.new(options)
  end
    
  describe "the top-level function to run the tests" do
    before(:each) do
      @processors = [mock("processor 0"), mock("processor 1"), mock("processor 2")]
      @suite = CIAT::Suite.new(
        :processors => @processors, 
        :feedback => @feedback)
    end
    
    it "should have a size based on the number of test files" do
      @suite.stub_chain(:test_files, :size).and_return(42)

      @suite.size.should == 42
    end

    it "should run tests on no test files" do    
      @feedback.should_receive(:pre_tests).with(@suite)
      @feedback.should_receive(:post_tests).with(@suite)
    
      @suite.run.should == []
      @suite.results.should == []
    end
  
    it "should run tests on test files" do
      folder = "THE_FOLDER"
      test_files = [mock("test file 1"), mock("test file 2")]
      elements = [mock("element 1"), mock("element 2")]
      results = [mock("result 1"), mock("result 2")]

      @feedback.should_receive(:pre_tests).with(@suite)
      @suite.should_receive(:test_files).with().and_return(test_files)
      expect_create_and_run_test(test_files[0], results[0])
      expect_create_and_run_test(test_files[1], results[1])
      @feedback.should_receive(:post_tests).with(@suite)
    
      @suite.run.should == results
      @suite.results.should == results
    end
    
    def expect_create_and_run_test(test_file, result)
      test = mock("test for #{test_file}")
      @suite.should_receive(:create_test).with(test_file).and_return(test)
      test.should_receive(:run).and_return(result)
    end
  end
end
