require 'spec_helper'

describe "parrot-error" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/compile-fail.html")
  end

  it "should show the standard output" do
    @doc.should have_selector(".source")
  end
  
  it "should show the diff of the standard output" do
    @doc.should have_selector(".compilation_diff")
  end
  
  it "should indicate that the second processor was not run" do
    @doc.should have_selector("p", :content => "Not executed.")
  end
end