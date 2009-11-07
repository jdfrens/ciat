require 'rubygems'
require 'webrat'

describe "parrot-error" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = Webrat::XML.html_document(open("temp/parrot-error.html").readlines)
  end

  it "should not show the standard output" do
    @doc.should_not have_selector(".execution_generated")
  end
  
  it "should show the error output" do
    @doc.should have_selector(".execution_error_generated")
  end
  
  it "should describe a sad path" do
    @doc.should have_selector("h3", :content => "sad path")
  end
end