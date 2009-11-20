require 'spec_helper'

describe "java-parrot.html" do
  include Webrat::Matchers
  
  folder "java", "parrot"
  
  describe "a happy path" do
    happy_path
    
    it_should_have_only_the_elements "source", "compilation_generated", "execution_generated"

    it_should_indicate_a_happy_path
  end
  
  describe "a sad path (for just the in-Java compiler)" do
    sad_path
    
    it_should_have_only_the_elements "source", "compilation_error_generated"
    
    it_should_indicate_a_sad_path
  end
end
