require 'spec_helper'

describe "java-interpreter-success.html" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/java-interpreter-success.html")
  end

  describe "the success of a happy path" do
    before(:each) do
      @file = "ciat_java_interpreter_success_basic_success_ciat"
    end
    
    it "should have the appropriate elements" do
      @doc.should have_element(".execution_generated")
    end
    
    it "should not have unnecessary elements" do
      @doc.should_not have_element(".execution_error_generated")
    end

    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  
  describe "the success of a sad path" do
    before(:each) do
      @file = "ciat_java_interpreter_success_basic_sad_path_success_ciat"
    end
    
    it "should have the appropriate elements" do
      @doc.should have_element(".execution_error_generated")
    end
    
    it "should not have the unnecessary elements" do
      @doc.should_not have_element(".execution_generated")
    end

    it "should describe a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end