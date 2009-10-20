require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::TestElement do
  before(:each) do
    @name = mock("name")
    @filename = mock("filename")
    @content = mock("content")
    @element = CIAT::TestElement.new(@name, @filename, @content)
  end
  
  describe "treating as a file" do
    it "should be written as a file when interesting content" do
      @element.should_receive(:write_file).with(@filename, @content)

      @element.as_file.should == @filename
    end

    it "should just return filename for pending content" do
      test_element = CIAT::TestElement.new(:some_name, @filename, nil)
      
      CIAT::Cargo.should_not_receive(:write_file)
      
      test_element.as_file.should == @filename
    end
  end
  
  describe "having content" do
    it "should have cached content" do
      @element.content.should == @content
    end
    
    it "should read when content is empty" do
      read_content = mock("read content")
      test_element = CIAT::TestElement.new(:some_name, @filename, nil)
      
      test_element.should_receive(:read_file).
        with(@filename).and_return(read_content)
      
      test_element.content.should == read_content
    end
  end
  
  describe "finding template files" do
    it "should have a template file based on the name" do
      entry = mock("entry")
    
      @element.should_receive(:yaml_entry).at_least(:once).and_return(entry)
      entry.should_receive(:[]).with("template").and_return("filename")
    
      @element.template.should == File.join("elements", "filename")
    end
    
    it "should raise an error when name is missing from YAML file" do
      @element.should_receive(:yaml_entry).and_return(nil)

      lambda { @element.template }.should raise_error
    end
  end
  
  it "should describe the test element" do
    entry, description = mock("entry"), mock("description")
    
    @element.should_receive(:yaml_entry).and_return(entry)
    entry.should_receive(:[]).with("description").and_return(description)
    
    @element.describe.should == description
  end
  
  it "should get a YAML entry" do
    metadata, entry = mock("metadata"), mock("entry")
  
    @element.should_receive(:metadata).and_return(metadata)
    @name.should_receive(:to_s).at_least(:once).and_return("name")
    metadata.should_receive(:[]).with("name").and_return(entry)
    
    @element.yaml_entry.should == entry
  end
end
