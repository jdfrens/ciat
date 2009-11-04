require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Suite do
  include MockHelpers
  
  it "should construct with suite builder" do
    options = mock("options")
    suite_builder = mock("suite builder")
    processors, output_folder, ciat_files, feedback =
      mock("processors"), mock("output folder"),
      mock("ciat files"), mock("feedback")
    suite = mock("suite")
    
    CIAT::SuiteBuilder.should_receive(:new).
      with(options).and_return(suite_builder)
    suite_builder.should_receive(:build_processors).and_return(processors)
    suite_builder.should_receive(:build_output_folder).
      and_return(output_folder)
    suite_builder.should_receive(:build_ciat_files).and_return(ciat_files)
    suite_builder.should_receive(:build_feedback).and_return(feedback)
    CIAT::Suite.should_receive(:new).
      with(processors, output_folder, ciat_files, feedback).and_return(suite)
      
    CIAT::Suite.build(options).should == suite
  end
    
  describe "the top-level function to run the tests" do
    before(:each) do
      @processors = array_of_mocks(3, "processor")
      @output_folder = mock("output folder")
      @ciat_files = array_of_mocks(3, "ciat file")
      @feedback = mock("feedback")
      @suite = CIAT::Suite.new(
                  @processors, @output_folder, @ciat_files, @feedback
                  )
    end
    
    it "should have a size based on the number of test files" do
      @suite.stub_chain(:ciat_files, :size).and_return(42)

      @suite.size.should == 42
    end

    it "should run tests on test files" do
      folder = "THE_FOLDER"
      results = array_of_mocks(3, "result")

      @feedback.should_receive(:pre_tests).with(@suite)
      expect_create_and_run_test(@ciat_files[0], results[0])
      expect_create_and_run_test(@ciat_files[1], results[1])
      expect_create_and_run_test(@ciat_files[2], results[2])
      @feedback.should_receive(:post_tests).with(@suite)
    
      @suite.run.should == results
      @suite.results.should == results
    end
    
    def expect_create_and_run_test(ciat_file, result)
      test = mock("test for #{ciat_file}")
      @suite.should_receive(:create_test).with(ciat_file).and_return(test)
      test.should_receive(:run).and_return(result)
    end
  end
end
