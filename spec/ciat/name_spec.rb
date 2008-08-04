require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Namer, "factory method" do
  before(:each) do
    @filenames = [mock("filename1"), mock("filename2"), mock("filename3")]
    @testnames = [mock("testname1"), mock("testname2"), mock("testname3")]
  end
  
  it "should use default values" do
    expect_standard_dir_lookup("ciat/**/*.ciat")
    CIAT::Namer.create().should == @testnames
  end
  
  it "should use specified pattern" do
    expect_standard_dir_lookup("ciat/**/*.foobar")
    CIAT::Namer.create(:pattern => "*.foobar").should == @testnames
  end
  
  it "should use specified folder" do
    expect_standard_dir_lookup("jimmy/**/*.ciat", :folder => "jimmy")
    CIAT::Namer.create(:folder => "jimmy").should == @testnames
  end
  
  it "should use specified output folder" do
    output_folder = mock("output folder")
    expect_standard_dir_lookup("ciat/**/*.ciat", :output_folder => output_folder)
    CIAT::Namer.create(:output_folder => output_folder).should == @testnames
  end
  
  it "should use specified folder and specified pattern and specified output folder" do
    output_folder = mock("output folder")
    expect_standard_dir_lookup("angel/**/*_ppc.ciat", :folder => "angel", :output_folder => output_folder)
    CIAT::Namer.create(:folder => "angel", :pattern => "*_ppc.ciat", :output_folder => output_folder).should == @testnames    
  end
  
  it "should use specified files without lookup" do
    expect_filenames_turned_into_testnames(:folder => nil, :output_folder => CIAT::Namer::OUTPUT_FOLDER)
    CIAT::Namer.create(:files => @filenames).should == @testnames
  end
  
  def expect_standard_dir_lookup(path, options={})
    options = { :folder => 'ciat', :output_folder => CIAT::Namer::OUTPUT_FOLDER}.merge(options)
    Dir.should_receive(:[]).with(path).and_return(@filenames)
    expect_filenames_turned_into_testnames(options)
  end
  
  def expect_filenames_turned_into_testnames(options)
    @filenames.zip(@testnames) do |filename, testname|
      CIAT::Namer.should_receive(:new).with(filename, options).and_return(testname)
    end
  end
end

describe CIAT::Namer do
  before(:each) do
    @filenames = CIAT::Namer.new("/ciat/filename.ciat")
    @temp_directory = File.join(Dir.pwd, 'temp')
  end
    
  it "should have a test file" do
    @filenames.test_file.should == "/ciat/filename.ciat"
  end

  it "should have a source file" do
    @filenames.source.should == "#{@temp_directory}/filename.source"
  end
  
  it "should have a compilation_expected file" do
    @filenames.compilation_expected.should == "#{@temp_directory}/filename.compilation.expected"
  end
  
  it "should have a compilation_generated file" do
    @filenames.compilation_generated.should == "#{@temp_directory}/filename.compilation.generated"
  end
  
  it "should have a output_expected file" do
    @filenames.output_expected.should == "#{@temp_directory}/filename.output.expected"
  end
  
  it "should have a output_generated file" do
    @filenames.output_generated.should == "#{@temp_directory}/filename.output.generated"    
  end
  
  it "should have a compilation_diff file" do
    @filenames.compilation_diff.should == "#{@temp_directory}/filename.compilation.diff"    
  end
  
  it "should have a output_diff file" do
    @filenames.output_diff.should == "#{@temp_directory}/filename.output.diff"    
  end
  
  it "should have a temp_directory file" do
    @filenames.temp_directory.should == "#{@temp_directory}"
  end
  
end
