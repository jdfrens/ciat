require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "optional-element output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :processor  
  attr_reader :crate
  attr_reader :optional_elements
  
  before(:each) do
    @processor = mock('processor')
    @crate = mock("crate")
    @erb = ERB.new(File.read("lib/templates/detail_row/optional_elements.html.erb"))
  end

  it "should handle no optional elements" do
    @optional_elements = []
    
    doc = process_erb
  end
  
  it "should process one used optional element" do
    @optional_elements = [:element0]

    expect_optional_element(:element0, "element 0 content", "element 0 description")
    
    doc = process_erb
    doc.should have_optional_element_content(:element0, "element 0 content")
    doc.should have_optional_element_description(:element0, "element 0 description")
  end
  
  it "should process one unused optional element" do
    @optional_elements = [:element0]

    expect_unset_optional_element(:element0)
    
    doc = process_erb
    doc.should have_no_optional_element(:element0)
  end
  
  it "should process many optional elements" do
    @optional_elements = [:a, :b, :c]

    expect_optional_element(:a, "aaa", "AAA")
    expect_optional_element(:b, "bbb", "BBB")
    expect_optional_element(:c, "ccc", "CCC")
    
    doc = process_erb
    doc.should have_optional_element_content(:a, "aaa")
    doc.should have_optional_element_description(:a, "AAA")
    doc.should have_optional_element_content(:b, "bbb")
    doc.should have_optional_element_description(:b, "BBB")
    doc.should have_optional_element_content(:c, "ccc")
    doc.should have_optional_element_description(:c, "CCC")
  end
  
  it "should process many, varied optional elements" do
    @optional_elements = [:a, :b, :c]

    expect_optional_element(:a, "aaa", "AAA")
    expect_unset_optional_element(:b)
    expect_optional_element(:c, "ccc", "CCC")
    
    doc = process_erb
    doc.should have_optional_element_content(:a, "aaa")
    doc.should have_optional_element_description(:a, "AAA")
    doc.should have_no_optional_element(:b)
    doc.should have_optional_element_content(:c, "ccc")
    doc.should have_optional_element_description(:c, "CCC")
  end
  
  def expect_unset_optional_element(element)
    @crate.should_receive(:element).with(element).at_least(:once).and_return(nil)
  end
  
  def expect_optional_element(element, content, description)
    @crate.should_receive(:element).with(element).at_least(:once).and_return(content)
    @processor.should_receive(:description).with(element).and_return(description)
  end
end
