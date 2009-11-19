require 'rubygems'
require 'webrat'
require 'spec_helper'

describe "confirm the common elements in the HTML documents" do
  include Webrat::Matchers
  
  Dir["temp/*.html"].each do |file|
    describe file do
      define_method(:file) { file }
      
      def this_doc
        @cached_doc ||= Nokogiri::HTML.parse(open(file).read)
      end
      
      it "should include prototype javascript" do
        this_doc.should have_selector("script",
                      :src => "prototype.js",  :type => "text/javascript")
      end

      it "should include a link to a CSS file" do
        this_doc.should have_selector("link", :rel => "stylesheet",
                        :href => "ciat.css", :type => "text/css")
      end

      it "should include a test-count span" do
        this_doc.should have_selector("span.test-count")
      end
    end
  end
end
