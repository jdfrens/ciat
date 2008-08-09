require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Cargo, "initializing" do
  before(:each) do
    @filenames = [mock("filename1"), mock("filename2"), mock("filename3")]
    @crates = [mock("crate1"), mock("crate2"), mock("crate3")]
  end

  describe "building crates" do
    it "should use default values" do
      expect_dir_lookup("ciat/**/*.ciat")
      CIAT::Cargo.new().crates.should == @crates
    end
  
    it "should use specified pattern" do
      expect_dir_lookup("ciat/**/*.foobar")
      CIAT::Cargo.new(:pattern => "*.foobar").crates.should == @crates
    end
  
    it "should use specified folder" do
      expect_dir_lookup("jimmy/**/*.ciat", :folder => "jimmy")
      CIAT::Cargo.new(:folder => "jimmy").crates.should == @crates
    end
  
    it "should use specified output folder" do
      expect_dir_lookup("ciat/**/*.ciat", :output_folder => "SPECIFIED FOLDER")
      CIAT::Cargo.new(:output_folder => "SPECIFIED FOLDER").crates.should == @crates
    end
    
    it "should use specified files without lookup" do
      expect_filenames_turned_into_crates(:folder => nil, :output_folder => CIAT::Cargo::OUTPUT_FOLDER)
      CIAT::Cargo.new(:files => @filenames).crates.should == @crates
    end
  end
  
  describe "report filename" do
    it "should use default report filename" do
      CIAT::Cargo.new().report_filename.should == 
        File.join(CIAT::Cargo::OUTPUT_FOLDER, CIAT::Cargo::REPORT_FILENAME)
    end
  
    it "should use specified output folder for report filename" do
      expect_dir_lookup("ciat/**/*.ciat", :output_folder => "SPECIFIED FOLDER")
      CIAT::Cargo.new(:output_folder => "SPECIFIED FOLDER").report_filename.should == 
        File.join("SPECIFIED FOLDER", CIAT::Cargo::REPORT_FILENAME)
    end
  
    it "should use specified report filename (and default output folder)" do
      CIAT::Cargo.new(:report_filename => "jimmy.html").report_filename.should ==
        File.join(CIAT::Cargo::OUTPUT_FOLDER, "jimmy.html")
    end
  end
  
  it "should use specified folder and specified pattern and specified output folder and specified report filename" do
    output_folder, report_filename, report_path = mock("output folder"), mock("report filename"), mock("report path")
    expect_dir_lookup("angel/**/*_ppc.ciat", :folder => "angel", :output_folder => output_folder)
    File.should_receive(:join).with("angel", "**", "*_ppc.ciat").and_return("angel/**/*_ppc.ciat")
    File.should_receive(:join).with(output_folder, report_filename).and_return(report_path)
    overspecified_cargo = CIAT::Cargo.new(:folder => "angel", :pattern => "*_ppc.ciat", :output_folder => output_folder, :report_filename => report_filename)
    overspecified_cargo.crates.should == @crates
    overspecified_cargo.report_filename.should == report_path
  end
  
  it "should have a size based on number of crates" do
    expect_dir_lookup("ciat/**/*.ciat")
    CIAT::Cargo.new().size.should == 3
  end

  def expect_dir_lookup(path, options={})
    options = { :folder => 'ciat', :output_folder => CIAT::Cargo::OUTPUT_FOLDER }.merge(options)
    Dir.should_receive(:[]).with(path).and_return(@filenames)
    expect_filenames_turned_into_crates(options)
  end
  
  def expect_filenames_turned_into_crates(options)
    @filenames.zip(@crates) do |filename, crate|
      CIAT::Crate.should_receive(:new).with(filename, duck_type(:write_file, :output_folder)).and_return(crate)
    end
  end
end

describe CIAT::Cargo, "writing a file" do
  it "should create folder and write file" do
    content, response = mock("content"), mock("response")
    cargo = CIAT::Cargo.new(:files => [], :output_folder => "NOT USED")
    
    FileUtils.should_receive(:mkdir_p).with("a/b/c/d")
    File.should_receive(:open).with("a/b/c/d/foo.ciat", "w").and_return(response)
    
    cargo.write_file("a/b/c/d/foo.ciat", content).should == response
  end
end
