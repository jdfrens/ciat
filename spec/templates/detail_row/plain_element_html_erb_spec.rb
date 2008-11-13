require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "element output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :processor  
  attr_reader :element
  
  before(:each) do
    @processor = mock('processor')
    @erb = ERB.new(File.read("lib/templates/detail_row/plain_element.html.erb"))
  end

  it "should process a plain element" do
    @element = mock_element(:element0, "element 0 description", "element 0 content")
    
    doc = process_erb
    doc.should have_element_content(:element0, "element 0 content")
    doc.should have_element_description(:element0, "element 0 description")
  end
      
  def mock_element(name, description, content)
    element = mock(name)
    element.stub!(:name).and_return(name)
    @processor.stub!(:describe).with(name).and_return(description)
    element.stub!(:content).and_return(content)
    element
  end
  
  def have_element_description(element, expected_description)
    have_inner_html("div.#{element} th", expected_description)
  end
  
  def have_element_content(element, expected_content)
    have_inner_html("div.#{element} pre", expected_content)
  end
end
