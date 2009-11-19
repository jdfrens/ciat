require 'spec_helper'

describe "parrot errors" do
  include Webrat::Matchers
  
  folder "parrot", "red"

  describe "sad path" do
    sad_path
    
    it_should_have_only_the_elements "source", "execution_generated",
      "execution_error_diff"
  
    it "should describe a sad path" do
      @doc.should indicate_sad_path
    end
  end
end