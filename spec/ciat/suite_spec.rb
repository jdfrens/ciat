require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Suite, "top level test function" do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
    @feedback = mock("feedback")
  end
  
  it "should get a directory listing of CIAT files" do
    filenames = mock("filenames")
    
    Dir.should_receive(:[]).with("ciat/*.ciat").and_return(filenames)
    suite = CIAT::Suite.new(@compiler, @executor)
    
    suite.filenames.should == filenames
  end
  
  it "should have a size based on the number of test files" do
    filenames = mock("filenames")

    filenames.should_receive(:size).and_return(42)
    suite = CIAT::Suite.new(@compiler, @executor, :filenames => filenames)
    
    suite.size.should == 42
  end
  
  it "should run tests on no test files" do
    html = mock("html")
    
    suite = CIAT::Suite.new(@compiler, @executor, :filenames => [], :feedback => @feedback)
    suite.should_receive(:generate_html).with([]).and_return(html)
    suite.should_receive(:write_file).with(suite.report_filename, html)
    @feedback.should_receive(:post_tests).with(suite)
    
    suite.run.should == []
  end
  
  it "should run tests on test files" do
    filenames = [mock("filename1"), mock("filename2")]
    results = [mock("result1"), mock("result2")]
    html = mock("html")
    
    suite = CIAT::Suite.new(@compiler, @executor, :filenames => filenames, :feedback => @feedback)
    filenames.zip(results).each do |filename, result|
      suite.should_receive(:run_test).with(filename).and_return(result)
    end  
    suite.should_receive(:generate_html).with(results).and_return(html)
    suite.should_receive(:write_file).with(suite.report_filename, html)    
    @feedback.should_receive(:post_tests).with(suite)
    
    suite.run.should == results
  end

  it "should run a test" do
    file, filename, test, result = mock("file"), mock("filename"), mock("test"), mock("result")
    
    CIAT::Filenames.should_receive(:new).with(file).and_return(filename)
    CIAT::Test.should_receive(:new).with(filename, @compiler, @executor).and_return(test)
    test.should_receive(:run).and_return(result)
    suite = CIAT::Suite.new(@compiler, @executor)
    
    suite.run_test(file).should == result
  end
  
  it "should generate html" do
    suite = CIAT::Suite.new(@compiler, @executor)
    
    erb_template, result = mock("erb_template"), mock("result")
    ERB.should_receive(:new).with(suite.template).and_return(erb_template)
    erb_template.should_receive(:result).with(duck_type(:call)).and_return(result)
    
    suite.generate_html(nil)
  end
  
  it "should write file" do
    # too mundane to test
  end
end
