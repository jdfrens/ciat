require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Suite do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
    @cargo = mock("cargo")
    @feedback = mock("feedback")
  end
  
  it "should construct cargo with options to constructor" do
    CIAT::Cargo.should_receive(:new).with(:option1 => "optionA", :option2 => "optionB", :option3 => "optionC").and_return(@cargo)
    suite = CIAT::Suite.new(@compiler, @executor, :option1 => "optionA", :option2 => "optionB", :option3 => "optionC")
    suite.cargo.should == @cargo
  end
  
  it "should have a size based on the number of test files" do
    suite = CIAT::Suite.new(@compiler, @executor, :cargo => @cargo)
    
    @cargo.should_receive(:size).and_return(42)

    suite.size.should == 42
  end

  describe "the top-level function to run the tests" do
    it "should run tests on no test files" do
      suite = CIAT::Suite.new(@compiler, @executor, :cargo => @cargo, :feedback => @feedback)
    
      @cargo.should_receive(:copy_suite_data)
      @cargo.should_receive(:crates).and_return([])
      suite.should_receive(:generate_report).with()
      @feedback.should_receive(:post_tests).with(suite)
    
      suite.run.should == []
      suite.results.should == []
    end
  
    it "should run tests on test files" do
      folder = "THE_FOLDER"
      crates = [mock("crate1"), mock("crate2")]
      results = [mock("result1"), mock("result2")]
      suite = CIAT::Suite.new(@compiler, @executor, :cargo => @cargo, :feedback => @feedback)

      @cargo.should_receive(:copy_suite_data)
      @cargo.should_receive(:crates).with().and_return(crates)
      crates.zip(results).each do |crate, result|
        suite.should_receive(:run_test).with(crate).and_return(result)
      end
      suite.should_receive(:generate_report).with()
      @feedback.should_receive(:post_tests).with(suite)
    
      suite.run.should == results
      suite.results.should == results
    end
  end

  it "should run a single test" do
    crate, test, result = mock("crate"), mock("test"), mock("result")
    suite = CIAT::Suite.new(@compiler, @executor, :cargo => @cargo, :feedback => @feedback)

    CIAT::Test.should_receive(:new).with(crate, @compiler, @executor).and_return(test)
    test.should_receive(:run).and_return(result)
    
    suite.run_test(crate).should == result
  end
  
  it "should generate a report" do
    html, report_filename = mock("html"), mock("report filename")
    suite = CIAT::Suite.new(@compiler, @executor, :cargo => @cargo, :feedback => @feedback)
    suite.should_receive(:generate_html).with().and_return(html)
    @cargo.should_receive(:report_filename).and_return(report_filename)
    @cargo.should_receive(:write_file).with(report_filename, html)
    
    suite.generate_report
  end
  
  it "should generate html" do
    erb_template, binding, result = mock("erb_template"), mock("binding"), mock("result")
    suite = CIAT::Suite.new(@compiler, @executor, :cargo => @cargo)
    
    ERB.should_receive(:new).with(suite.template).and_return(erb_template)
    suite.should_receive(:binding).with().and_return(binding)
    erb_template.should_receive(:result).with(binding).and_return(result)
    
    suite.generate_html()
  end
end
