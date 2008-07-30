require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Filenames do
  before(:each) do
    @filenames = CIAT::Filenames.new("/ciat/filename.ciat")
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
