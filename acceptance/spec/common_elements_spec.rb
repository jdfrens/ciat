require 'rubygems'
require 'webrat'

describe "confirm the common elements in the HTML documents" do
  include Webrat::Matchers
  
  def all_html_files
    Dir["temp/java.html"]
  end
  
  before(:each) do
    @docs = all_html_files.map do |file|
      Webrat::XML.html_document(open(file).readlines)
    end
  end
  
  it "should include prototype javascript" do
    each_doc_should have_selector("script",
                    :src => "prototype.js",  :type => "text/javascript")
  end
  
  it "should include a link to a CSS file" do
    each_doc_should have_selector("link", :rel => "stylesheet",
                    :href => "ciat.css", :type => "text/css")
  end
  
  it "should include a test-count span" do
    each_doc_should have_selector("span.test-count")
  end
  
  def each_doc_should(matcher)
    @docs.each do |doc|
      doc.should matcher
    end
  end
end