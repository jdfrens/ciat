require 'rubygems'
require 'webrat'

describe "parrot" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = Webrat::XML.html_document(open("temp/parrot.html").readlines)
  end

  it "should show the standard output" do
    @doc.should have_selector(".execution_generated")
  end
  
  it "should not show the error output" do
    @doc.should_not have_selector(".execution_error_generated")
  end
  
  it "should describe a happy path" do
    @doc.should have_selector("h3", :content => "happy path")
  end
end