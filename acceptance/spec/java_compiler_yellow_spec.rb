require 'spec_helper'

describe "java-compiler-yellow.html" do
  include Webrat::Matchers
  
  folder "java", "compiler", "yellow"

  describe "happy path" do
    happy_path
    
    it_should_have_only_the_elements "source", "compilation_generated", "compilation_error_generated"
    
    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  describe "sad path" do
    sad_path
    
    it_should_have_only_the_elements "source", "compilation_error_generated", "compilation_generated"
    
    it "should indicate a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end