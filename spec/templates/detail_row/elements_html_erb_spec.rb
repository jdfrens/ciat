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
    # TODO: make some content assertions?
  end
  
  it "should process one used element" do
    @elements = [mock("element")]
    
    doc = process_erb
    # TODO: make some content assertions
  end
  
  it "should process many elements" do
    @elements = [mock("element 0"), mock("element 1"), mock("element 2")]
    
    doc = process_erb
    # TODO: make some content assertions
  end
end
