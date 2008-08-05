require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Suite, "top level test function" do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
    @feedback = mock("feedback")
  end
  
  it "should get a directory listing of CIAT test names" do
    testnames = mock("testnames")
    
    Dir.should_receive(:[]).with("ciat/*.ciat").and_return(testnames)
    suite = CIAT::Suite.new(@compiler, @executor)
    
    suite.testnames.should == testnames
  end
  
  it "should handle subfolders" do
    folder, testnames = "THE_FOLDER", mock("testnames")
    
    Dir.should_receive(:[]).with("ciat/THE_FOLDER/*.ciat").and_return(testnames)
    suite = CIAT::Suite.new(@compiler, @executor, :folder => folder)
    
    suite.testnames.should == testnames
  end
  
  it "should have a size based on the number of test files" do
    testnames = mock("testnames")

    testnames.should_receive(:size).and_return(42)
    suite = CIAT::Suite.new(@compiler, @executor, :testnames => testnames)
    
    suite.size.should == 42
  end
  
  it "should run tests on no test files" do
    html = mock("html")
    
    suite = CIAT::Suite.new(@compiler, @executor, :testnames => [], :feedback => @feedback)
    suite.should_receive(:generate_html).with([]).and_return(html)
    suite.should_receive(:write_file).with(suite.report_filename, html)
    @feedback.should_receive(:post_tests).with(suite)
    
    suite.run.should == []
  end
  
  it "should run tests on test files" do
    folder = "THE_FOLDER"
    testnames = [mock("testname1"), mock("testname1")]
    results = [mock("result1"), mock("result2")]
    html = mock("html")
    
    suite = CIAT::Suite.new(@compiler, @executor, :testnames => testnames, :feedback => @feedback)
    testnames.zip(results).each do |testname, result|
      suite.should_receive(:run_test).with(testname).and_return(result)
    end  
    suite.should_receive(:generate_html).with(results).and_return(html)
    suite.should_receive(:write_file).with(suite.report_filename, html)    
    @feedback.should_receive(:post_tests).with(suite)
    
    suite.run.should == results
  end

  it "should run a test" do
    testname, folder, namer, test, result = mock("testname"), mock("folder"), mock("namer"), mock("test"), mock("result")
    
    CIAT::CiatNames.should_receive(:new).with(testname).and_return(namer)
    CIAT::Test.should_receive(:new).with(namer, @compiler, @executor).and_return(test)
    test.should_receive(:run).and_return(result)
    suite = CIAT::Suite.new(@compiler, @executor)
    
    suite.run_test(testname).should == result
  end
  
  it "should generate html" do
    erb_template, result = mock("erb_template"), mock("result")
    suite = CIAT::Suite.new(@compiler, @executor)
    
    ERB.should_receive(:new).with(suite.template).and_return(erb_template)
    erb_template.should_receive(:result).with(duck_type(:call)).and_return(result)
    
    suite.generate_html(nil)
  end
  
  it "should write file" do
    # too mundane to test
  end
end
