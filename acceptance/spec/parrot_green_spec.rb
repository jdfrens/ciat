require 'spec_helper'

describe "parrot-green.html" do
  include Webrat::Matchers
  
  folder "parrot", "green"
  
  describe "a green, happy path" do
    happy_path
    
    it_should_have_only_the_elements "source", "execution_generated"
    
    it "should describe a happy path" do
      @doc.should indicate_a_happy_path
    end
  end

  describe "a green, happy path with a command line" do
    happy_path("command_line")
    
    it_should_have_only_the_elements "source", "command_line", "execution_generated"
    
    it "should describe a happy path" do
      @doc.should indicate_a_happy_path
    end
  end
  
  describe "a green, sad path" do
    sad_path
    
    it_should_have_only_the_elements "source", "execution_error_generated"
    
    it "should describe a sad path" do
      @doc.should indicate_a_sad_path
    end
  end
end