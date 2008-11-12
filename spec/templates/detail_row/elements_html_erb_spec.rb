require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "element output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :processor  
  attr_reader :crate
  attr_reader :elements
  
  before(:each) do
    @processor = mock('processor')
    @crate = mock("crate")
    @erb = ERB.new(File.read("lib/templates/detail_row/elements.html.erb"))
  end

  it "should handle no elements" do
    @elements = []
    
    doc = process_erb
  end
  
  it "should process one used element" do
    @elements = [mock_element(:element0, "element 0 description", "element 0 content")]
    
    doc = process_erb
    doc.should have_element_content(:element0, "element 0 content")
    doc.should have_element_description(:element0, "element 0 description")
  end
  
  it "should process many elements" do
    @elements = [
      mock_element(:a, "AAA", "aaa"),
      mock_element(:b, "BBB", "bbb"), 
      mock_element(:c, "CCC", "ccc")]
    
    doc = process_erb
    doc.should have_element_content(:a, "aaa")
    doc.should have_element_description(:a, "AAA")
    doc.should have_element_content(:b, "bbb")
    doc.should have_element_description(:b, "BBB")
    doc.should have_element_content(:c, "ccc")
    doc.should have_element_description(:c, "CCC")
  end
    
  def mock_element(name, description, content)
    element = mock(name)
    element.stub!(:description).and_return(description)
    element.stub!(:name).and_return(name)
    element.stub!(:content).and_return(content)
    element
  end
  
  def have_no_element(element)
    have_none("div.#{element}")
  end
  
  def have_element_description(element, expected_description)
    have_inner_html("div.#{element} th", expected_description)
  end
  
  def have_element_content(element, expected_content)
    have_inner_html("div.#{element} pre", expected_content)
  end
end
