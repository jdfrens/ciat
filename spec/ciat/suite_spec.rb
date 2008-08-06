require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Suite, "top level test function" do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
    @cargo = mock("cargo")
    @feedback = mock("feedback")
  end
  
  it "should have a size based on the number of test files" do
    suite = CIAT::Suite.new(@compiler, @executor, @cargo)
    
    @cargo.should_receive(:size).and_return(42)

    suite.size.should == 42
  end
  
  it "should run tests on no test files" do
    html, report_filename = mock("html"), mock("report filename")
    suite = CIAT::Suite.new(@compiler, @executor, @cargo, :feedback => @feedback)
    
    @cargo.should_receive(:create_output_folder)
    @cargo.should_receive(:crates).and_return([])
    suite.should_receive(:generate_html).with([]).and_return(html)
    @cargo.should_receive(:report_filename).and_return(report_filename)
    suite.should_receive(:write_file).with(report_filename, html)
    @feedback.should_receive(:post_tests).with(suite)
    
    suite.run.should == []
  end
  
  it "should run tests on test files" do
    folder = "THE_FOLDER"
    crates = [mock("crate1"), mock("crate2")]
    results = [mock("result1"), mock("result2")]
    html, report_filename = mock("html"), mock("report filename")
    
    suite = CIAT::Suite.new(@compiler, @executor, @cargo, :feedback => @feedback)
    @cargo.should_receive(:create_output_folder)
    @cargo.should_receive(:crates).with().and_return(crates)
    crates.zip(results).each do |crate, result|
      suite.should_receive(:run_test).with(crate).and_return(result)
    end  
    suite.should_receive(:generate_html).with(results).and_return(html)
    @cargo.should_receive(:report_filename).and_return(report_filename)
    suite.should_receive(:write_file).with(report_filename, html)    
    @feedback.should_receive(:post_tests).with(suite)
    
    suite.run.should == results
  end

  it "should run a test" do
    crate, test, result = mock("crate"), mock("test"), mock("result")
    suite = CIAT::Suite.new(@compiler, @executor, @cargo, :feedback => @feedback)

    CIAT::Test.should_receive(:new).with(crate, @compiler, @executor).and_return(test)
    test.should_receive(:run).and_return(result)
    
    suite.run_test(crate).should == result
  end
  
  it "should generate html" do
    erb_template, result = mock("erb_template"), mock("result")
    suite = CIAT::Suite.new(@compiler, @executor, @cargo)
    
    ERB.should_receive(:new).with(suite.template).and_return(erb_template)
    erb_template.should_receive(:result).with(duck_type(:call)).and_return(result)
    
    suite.generate_html(nil)
  end
  
  it "should write file" do
    # too mundane to test
  end
end
