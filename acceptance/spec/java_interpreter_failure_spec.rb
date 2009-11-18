require 'spec_helper'

describe "java-interpreter-failure.html" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/java-interpreter-failure.html")
  end

  describe "the errors of a happy path" do
    before(:each) do
      @file = "ciat_java_interpreter_failure_happy_ciat"
    end
    
    it "should have the appropriate elements" do
      @doc.should have_element(".execution_diff")
      @doc.should have_element(".execution_error_generated")
    end
    
    it "should not have the irrelevant elements" do
      @doc.should_not have_element(".execution_error")
      @doc.should_not have_element(".execution_generated")
    end
    
    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  
  describe "the errors of a sad path" do
    before(:each) do
      @file = "ciat_java_interpreter_failure_sad_ciat"
    end
    
    it "should have the appropriate elements" do
      @doc.should have_element(".execution_error_diff")
      @doc.should have_element(".execution_generated")
    end
    
    it "should not have the irrelevant elements" do
      @doc.should_not have_element(".execution_error_generated")
    end
    
    it "should describe a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end