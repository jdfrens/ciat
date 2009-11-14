require 'spec_helper'

describe "parrot-sad" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/parrot-error.html")
  end

  it "should show the standard output" do
    @doc.should have_selector("#details_ciat_parrot_error_sad_path_ciat .execution_generated")
  end
  
  it "should show the error output" do
    @doc.should have_selector("#details_ciat_parrot_error_sad_path_ciat .execution_error_generated")
  end
  
  it "should describe a sad path" do
    @doc.should have_selector("#details_ciat_parrot_error_sad_path_ciat h3", :content => "sad path")
  end
end