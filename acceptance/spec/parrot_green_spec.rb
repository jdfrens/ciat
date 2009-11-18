require 'spec_helper'

describe "parrot-success.html" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/parrot-success.html")
  end

  describe "the success of a happy path" do
    before(:each) do
      @file = "ciat_parrot_success_command_line_ciat"
    end
    
    it_should_have_only_the_elements ".source", ".execution_generated"
    
    it "should describe a happy path" do
      @doc.should indicate_a_happy_path
    end
  end
end