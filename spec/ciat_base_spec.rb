require File.dirname(__FILE__) + '/spec_helper.rb'

describe CIAT::Suite, "top level test function" do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
  end
  
  it "should get a directory listing" do
    filenames = mock("filenames")
    Dir.should_receive(:[]).with("ciat/*.txt").and_return(filenames)
    
    suite = CIAT::Suite.new(@compiler, @executor)
    suite.filenames.should == filenames
  end
  
  it "should run tests on files" do
    files = ["file1.txt", "file2.txt"]
    filenames = [mock("filename1"), mock("filename2")]
    tests = [mock("test1"), mock("test2")]
    results = [mock("result1"), mock("result2")]
    html = mock("html")
    
    files.zip(filenames, tests, results).each do |file, filename, test, result|
      CIAT::Filenames.should_receive(:new).with(file).and_return(filename)
      CIAT::Test.should_receive(:new).with(filename, @compiler, @executor).and_return(test)
      test.should_receive(:run).and_return(result)
    end
    
    suite = CIAT::Suite.new(@compiler, @executor, files)
    suite.should_receive(:generate_html).with(results).and_return(html)
    suite.should_receive(:write_file).with(suite.report_filename, html)
    
    suite.run.should == results
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
