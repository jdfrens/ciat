require File.dirname(__FILE__) + '/spec_helper.rb'

describe CIAT::Filenames do
  before(:each) do
    @filenames = CIAT::Filenames.new("filename")
    @temp_directory = File.join(Dir.pwd, 'temp')
  end
    
  it "should have a test file" do
    @filenames.test_file.should == "#{Dir.pwd}/filename.txt"
  end

  it "should have a hobbes source file" do
    @filenames.source.should == "#{@temp_directory}/filename.source"
  end
  
  it "should have a expected_compilation file" do
    @filenames.expected_compilation.should == "#{@temp_directory}/filename.compilation.expected"
  end
  
  it "should have a generated_compilation file" do
    @filenames.generated_compilation.should == "#{@temp_directory}/filename.compilation.generated"
  end
  
  it "should have a expected_output file" do
    @filenames.expected_output.should == "#{@temp_directory}/filename.output.expected"
  end
  
  it "should have a generated_output file" do
    @filenames.generated_output.should == "#{@temp_directory}/filename.output.generated"    
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
