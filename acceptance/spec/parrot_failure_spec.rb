require 'spec_helper'

describe "parrot errors" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/parrot-failure.html")
  end

  describe "sad path" do
    before(:each) do
      @file = "ciat_parrot_failure_sad_path_ciat"
    end
    
    it_should_have_only_the_elements ".execution_generated",
      ".execution_error_diff"
  
    it "should describe a sad path" do
      @doc.should indicate_sad_path
    end
  end
end