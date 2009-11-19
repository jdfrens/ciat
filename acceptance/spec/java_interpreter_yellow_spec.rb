require 'spec_helper'

describe "java-interpreter-yellow.html" do
  include Webrat::Matchers
  
  folder "java", "interpreter", "yellow"

  describe "a yellow, happy path" do
    happy_path
    
    it_should_have_only_the_elements "source", "execution_generated", "execution_error_generated"
    
    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  
  describe "a yellow, sad path" do
    sad_path
    
    it_should_have_only_the_elements "source", "execution_error_generated", "execution_generated"
  
    it "should describe a sad path" do
      @doc.should indicate_sad_path 
    end
  end
end