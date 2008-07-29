require File.dirname(__FILE__) + '/spec_helper.rb'

describe CIAT::Suite, "top level test function" do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
  end
 
  it "should get a directory listing" do
    filenames, tests, html, result = mock("filenames"), mock("tests"), mock("html"), mock("result")
    Dir.should_receive(:[]).with("ciat/*.txt").and_return(filenames)

    suite = CIAT::Suite.new(@compiler, @executor)
    suite.should_receive(:run_tests_on_files).and_return(tests)
    suite.should_receive(:generate_html).with(tests).and_return(html)
    suite.should_receive(:write_file).with("#{CIAT::Filenames.temp_directory}/acceptance.html", html)

    suite.run
  end
  
  it "should run tests on files" do
    filenames = [mock("filename1"), mock("filename2")]
    results = [mock("result1"), mock("result2")]
    
    suite = CIAT::Suite.new(@compiler, @executor, filenames)
    suite.should_receive(:run_test).with(filenames[0]).and_return(results[0])
    suite.should_receive(:run_test).with(filenames[1]).and_return(results[1])
    suite.run_tests_on_files.should == results
  end
  
  it "should run a test" do
    filenames, test, result = mock("filenames"), mock("test"), mock("result")
    CIAT::Filenames.should_receive(:new).with("foo.txt").and_return(filenames)
    CIAT::Test.should_receive(:new).with(filenames, @compiler, @executor).and_return(test)
    test.should_receive(:run).and_return(result)
    
    suite = CIAT::Suite.new(@compiler, @executor, ["foo.txt"])
    suite.run_test("foo.txt").should == result
  end
  
  it "should write file" do
    # too mundane to test
  end
  
  it "should generate html" do
    suite = CIAT::Suite.new(@compiler, @executor)
    
    erb_template, result = mock("erb_template"), mock("result")
    ERB.should_receive(:new).with(suite.template).and_return(erb_template)
    erb_template.should_receive(:result).with(duck_type(:call)).and_return(result)
    
    suite.generate_html(nil)
  end
  
end
