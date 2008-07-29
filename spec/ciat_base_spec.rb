require File.dirname(__FILE__) + '/spec_helper.rb'

describe CIAT::Base, "top level test function" do
  before(:each) do
    @compiler = mock("compiler")
    @executor = mock("executor")
  end
 
  it "should get a directory listing " do
    filenames, tests, html, result = mock("filenames"), mock("tests"), mock("html"), mock("result")
    Dir.should_receive(:[]).with("ciat/*.txt").and_return(filenames)
    CIAT::Base.should_receive(:run_tests_on_files).with(filenames, @compiler, @executor).and_return(tests)
    CIAT::Base.should_receive(:generate_html).with(tests).and_return(html)
    CIAT::Base.should_receive(:write_file).with("acceptance.html", html).and_return(result)
    
    CIAT::Base.run_tests(@compiler, @executor).should == result
  end
  
  it "should run tests on files" do
    filenames = [mock("filename1"), mock("filename2")]
    results = [mock("result1"), mock("result2")]
    CIAT::Base.should_receive(:run_test).with(filenames[0], @compiler, @executor).and_return(results[0])
    CIAT::Base.should_receive(:run_test).with(filenames[1], @compiler, @executor).and_return(results[1])
    
    CIAT::Base.run_tests_on_files(filenames, @compiler, @executor).should == results
  end
  
  it "should run a test" do
    filenames, test, result = mock("filenames"), mock("test"), mock("result")
    CIAT::Filenames.should_receive(:new).with("foo").and_return(filenames)
    CIAT::Test.should_receive(:new).with(filenames, @compiler, @executor).and_return(test)
    test.should_receive(:run_test).and_return(result)
    
    CIAT::Base.run_test("foo.txt", @compiler, @executor).should == result
  end
  
  it "should write file" do
    # too mundane to test
  end
  
  it "should generate html" do
    erb_template, result = mock("erb_template"), mock("result")
    ERB.should_receive(:new).with(CIAT::Base.template).and_return(erb_template)
    erb_template.should_receive(:result).with(duck_type(:call)).and_return(result)
    
    CIAT::Base.generate_html(nil)
  end
  
end
