require 'spec_helper'

describe "java-compiler-success.html" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/java-compiler-success.html")
  end

  describe "the success of a happy path" do
    before(:each) do
      @file = "ciat_java_compiler_success_happy_ciat"
    end
    
    it_should_have_only_the_elements ".executed_generated"

    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  
  describe "the success of a sad path" do
    before(:each) do
      @file = "ciat_java_compiler_success_sad_ciat"
    end
    
    it_should_have_only_the_elements ".executed_error_generated"

    it "should describe a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end