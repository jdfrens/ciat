require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::CiatNames, "factory method" do
  before(:each) do
    @filenames = [mock("filename1"), mock("filename2"), mock("filename3")]
    @ciat_names = [mock("ciat_name1"), mock("ciat_name2"), mock("ciat_name3")]
  end
  
  it "should use default values" do
    expect_standard_dir_lookup("ciat/**/*.ciat")
    CIAT::CiatNames.create().should == @ciat_names
  end
  
  it "should use specified pattern" do
    expect_standard_dir_lookup("ciat/**/*.foobar")
    CIAT::CiatNames.create(:pattern => "*.foobar").should == @ciat_names
  end
  
  it "should use specified folder" do
    expect_standard_dir_lookup("jimmy/**/*.ciat", :folder => "jimmy")
    CIAT::CiatNames.create(:folder => "jimmy").should == @ciat_names
  end
  
  it "should use specified output folder" do
    output_folder = mock("output folder")
    expect_standard_dir_lookup("ciat/**/*.ciat", :output_folder => output_folder)
    CIAT::CiatNames.create(:output_folder => output_folder).should == @ciat_names
  end
  
  it "should use specified folder and specified pattern and specified output folder" do
    output_folder = mock("output folder")
    expect_standard_dir_lookup("angel/**/*_ppc.ciat", :folder => "angel", :output_folder => output_folder)
    CIAT::CiatNames.create(:folder => "angel", :pattern => "*_ppc.ciat", :output_folder => output_folder).should == @ciat_names    
  end
  
  it "should use specified files without lookup" do
    expect_filenames_turned_into_ciat_names(:folder => nil, :output_folder => CIAT::CiatNames::OUTPUT_FOLDER)
    CIAT::CiatNames.create(:files => @filenames).should == @ciat_names
  end
  
  def expect_standard_dir_lookup(path, options={})
    options = { :folder => 'ciat', :output_folder => CIAT::CiatNames::OUTPUT_FOLDER}.merge(options)
    Dir.should_receive(:[]).with(path).and_return(@filenames)
    expect_filenames_turned_into_ciat_names(options)
  end
  
  def expect_filenames_turned_into_ciat_names(options)
    @filenames.zip(@ciat_names) do |filename, ciat_name|
      CIAT::CiatNames.should_receive(:new).with(filename, options[:output_folder]).and_return(ciat_name)
    end
  end
end

describe CIAT::CiatNames, "generating interesting names" do
  before(:each) do
    @output_folder = mock("output folder")
    @ciat_names = CIAT::CiatNames.new("ciat/filename.ciat", @output_folder)
    @expected_filename = mock("expected filename")
  end
    
  it "should have a test file" do
    @ciat_names.test_file.should == "ciat/filename.ciat"
  end
  
  it "should have a basename" do
    @ciat_names.basename.should == "filename"
  end
  
  it "should have a folder name" do
    @ciat_names.folder_name.should == "ciat"
  end

  it "should have a source file" do
    set_expected_output_modifiers("source")
    @ciat_names.source.should == @expected_filename
  end
  
  it "should have a compilation_expected file" do
    set_expected_output_modifiers("compilation", "expected")
    @ciat_names.compilation_expected.should == @expected_filename
  end
  
  it "should have a compilation_generated file" do
    set_expected_output_modifiers("compilation", "generated")
    @ciat_names.compilation_generated.should == @expected_filename
  end
  
  it "should have a output_expected file" do
    set_expected_output_modifiers("output", "expected")
    @ciat_names.output_expected.should == @expected_filename
  end
  
  it "should have a output_generated file" do
    set_expected_output_modifiers("output", "generated")
    @ciat_names.output_generated.should == @expected_filename    
  end
  
  it "should have a compilation_diff file" do
    set_expected_output_modifiers("compilation", "diff")
    @ciat_names.compilation_diff.should == @expected_filename    
  end
  
  it "should have a output_diff file" do
    set_expected_output_modifiers("output", "diff")
    @ciat_names.output_diff.should == @expected_filename    
  end
  
  it "should have an output folder" do
    @ciat_names.output_folder.should == @output_folder
  end
  
  def set_expected_output_modifiers(*modifiers)
    @ciat_names.should_receive(:output_filename).with(*modifiers).and_return(@expected_filename)    
  end
end

describe CIAT::CiatNames, "generating actual file names" do
  before(:each) do
    @ciat_names = CIAT::CiatNames.new("philenamus", "outie")
  end
  
  it "should work with no modifiers" do
    @ciat_names.output_filename().should == "outie/philenamus"
  end
  
  it "should work with multiple modifiers" do
      @ciat_names.output_filename("one", "two", "three").should == "outie/philenamus_one_two_three"
  end
end