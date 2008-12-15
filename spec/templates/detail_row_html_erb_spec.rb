require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "detail row of test report" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :recursion
  
  before(:each) do
    @result = mock('result')
    @crate = mock('crate')
    @recursion = mock('recursion')
    @erb = ERB.new(File.read("lib/templates/detail_row.html.erb"))

    @result.should_receive(:crate).any_number_of_times.and_return(@crate)
  end
  
  it "should work with no processors" do
    @result.should_receive(:processors).at_least(:once).and_return([])
    
    doc = process_erb
    doc.should have_colspan(1)
  end

  it "should work with one processor" do
    processor = mock('processor')
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    expect_red_or_green(processor, "The Processor", "fake elements")

    doc = process_erb
    doc.should have_description("h3", "Results from The Processor")
    doc.should have_fake(:elements, "fake elements")
  end
  
  it "should work with many processors" do
    processors = [mock('processor 0'), mock('processor 1'), mock('processor 2')]
    
    @result.should_receive(:processors).any_number_of_times.and_return(processors)
    expect_red_or_green(processors[0], "Processor 0", "fake elements 0")
    expect_red_or_green(processors[1], "Processor 1", "fake elements 1")
    expect_red_or_green(processors[2], "Processor 2", "fake elements 2")

    doc = process_erb
    doc.should have_description("h3", "Results from Processor 0")
    doc.should have_fake(:elements, "fake elements 0")
    doc.should have_description("h3", "Results from Processor 1")
    doc.should have_fake(:elements, "fake elements 1")
    doc.should have_description("h3", "Results from Processor 2")
    doc.should have_fake(:elements, "fake elements 2")
  end
  
  def expect_red_or_green(processor, description, rendered_elements)
    elements = mock('elements')

    processor.should_receive(:describe).with().and_return(description)
    processor.should_receive(:elements).and_return(elements)
    @recursion.should_receive(:render).
      with("detail_row/elements",
       :elements => elements, :processor => processor, :crate => @crate).
      and_return(fake(:elements, rendered_elements))
  end
    
  def result
    @result
  end
end
