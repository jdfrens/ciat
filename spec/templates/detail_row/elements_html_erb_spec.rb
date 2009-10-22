require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "element output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :recursion
  attr_reader :processor  
  attr_reader :test_file
  attr_reader :elements
  
  before(:each) do
    @recursion = mock("recursion")
    @processor = mock('processor')
    @test_file = mock("test file")
    @erb = ERB.new(File.read("lib/templates/detail_row/elements.html.erb"))
  end

  it "should handle no elements" do
    @elements = []
    
    doc = process_erb
    doc.should have_inner_html("", /\s*/)
  end
  
  it "should process one used element" do
    @elements = [mock("element")]
    template = mock("template")
    
    @elements[0].should_receive(:template).and_return(template)
    @recursion.should_receive(:render).
      with(template, :element => @elements[0]).and_return(fake(:element, "faked element"))
    
    doc = process_erb
    doc.should have_fake(:element, "faked element")
  end
  
  it "should process many elements" do
    @elements = [mock("element 0"), mock("element 1"), mock("element 2")]
    templates = [mock("template 0"), mock("template 1"), mock("template 2")]
    
    @elements[0].should_receive(:template).and_return(templates[0])
    @recursion.should_receive(:render).
      with(templates[0], :element => @elements[0]).and_return(fake(:element0, "faked 0"))
    @elements[1].should_receive(:template).and_return(templates[1])
    @recursion.should_receive(:render).
      with(templates[1], :element => @elements[1]).and_return(fake(:element1, "faked 1"))
    @elements[2].should_receive(:template).and_return(templates[2])
    @recursion.should_receive(:render).
      with(templates[2], :element => @elements[2]).and_return(fake(:element2, "faked 2"))

    doc = process_erb
    doc.should have_fake(:element0, "faked 0")
    doc.should have_fake(:element1, "faked 1")
    doc.should have_fake(:element2, "faked 2")
  end
end
