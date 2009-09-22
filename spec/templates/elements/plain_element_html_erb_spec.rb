require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "element output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :element
  
  before(:each) do
    @erb = ERB.new(File.read("lib/templates/elements/plain.html.erb"))
  end

  it "should process a plain element" do
    @element = mock("element")
    
    @element.should_receive(:name).and_return(:the_name)
    @element.should_receive(:filename).and_return("the filename")
    @element.should_receive(:describe).at_least(:once).and_return("the description")
    @element.should_receive(:content).and_return("the content")
    
    doc = process_erb
    doc.should have_element_description(:the_name, "the description")
    doc.should have_element_content(:the_name, "the content")
  end
      
  def have_element_description(element, expected_description)
    have_inner_html("div.#{element} h4", expected_description)
  end
  
  def have_element_content(element, expected_content)
    have_inner_html("div.#{element} pre", expected_content)
  end
end
