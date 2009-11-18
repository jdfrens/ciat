require 'spec_helper'

describe "parrot-error" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/parrot-error.html")
  end

  describe "sad path" do
    before(:each) do
      @file = "ciat_parrot_error_sad_path_ciat"
    end
    
    it_should_have_only_the_elements ".execution_generated", 
      ".execution_error_generated"
  
    it "should describe a sad path" do
      @doc.should indicate_sad_path
    end
  end
end