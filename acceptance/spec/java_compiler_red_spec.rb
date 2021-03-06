require 'spec_helper'

describe "java-compiler-failure.html" do
  include Webrat::Matchers
  
  folder "java", "compiler", "red"
  
  describe "a red happy path" do
    happy_path
    
    it_should_have_only_the_elements "source", "compilation_diff"
    
    it "should describe a happy path" do
      @doc.should indicate_happy_path
    end
  end
  
  # describe "a red sad path" do
  #   sad_path
  # 
  #   it_should_have_only_the_elements "compilation_error_diff",
  #     "compilation_generated"
  #   
  #   it "should describe a sad path" do
  #     @doc.should indicate_sad_path 
  #   end
  # end
end