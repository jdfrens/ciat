require 'spec_helper'

describe "java-compiler-failure.html" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/java-compiler-failure.html")
  end

  describe "the errors of a happy path" do
    before(:each) do
      @file = "ciat_java_compiler_failure_happy_ciat"
    end
    
    it_should_have_only_the_elements ".execution_diff",
      ".execution_error_generated"
    
    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  
  describe "the errors of a sad path" do
    before(:each) do
      @file = "ciat_java_compiler_failure_sad_ciat"
    end

    it_should_have_only_the_elements ".execution_error_diff",
      ".execution_generated"
    
    it "should describe a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end