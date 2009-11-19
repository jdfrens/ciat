require 'spec_helper'

describe "java-compiler-green.html" do
  include Webrat::Matchers
  
  folder "java", "compiler", "green"
  
  describe "a green happy path" do
    happy_path
    
    it_should_have_only_the_elements "source", "compilation_generated"

    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  
  describe "a green sad path" do
    sad_path
    
    it_should_have_only_the_elements "source", "compilation_error_generated"
    
    it "should describe a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end