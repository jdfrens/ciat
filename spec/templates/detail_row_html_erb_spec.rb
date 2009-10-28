require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "detail row of test report" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :recursion
  
  before(:each) do
    @result = mock('result')
    @test_file = mock('test file')
    @recursion = mock('recursion')
    @erb = build_erb("lib/templates/detail_row.html.erb")

    @result.should_receive(:test_file).
      any_number_of_times.and_return(@test_file)
  end
  
  it "should work with no subresults" do
    @result.should_receive(:subresults).at_least(:once).and_return([])
    
    doc = process_erb
    doc.should have_colspan(1)
  end

  it "should work with one processor" do
    subresult = mock('subresult')
    
    @result.should_receive(:subresults).
      any_number_of_times.and_return([subresult])
    expect_red_or_green(subresult, "The Processor", "fake elements")

    doc = process_erb
    doc.should have_description("h3", "Results from The Processor")
    doc.should have_fake(:elements, "fake elements")
  end
  
  it "should work with many processors" do
    subresults = [mock('subresult 0'), mock('subresult 1'), mock('subresult 2')]
    
    @result.should_receive(:subresults).
      any_number_of_times.and_return(subresults)
    expect_red_or_green(subresults[0], "Processor 0", "fake elements 0")
    expect_red_or_green(subresults[1], "Processor 1", "fake elements 1")
    expect_red_or_green(subresults[2], "Processor 2", "fake elements 2")

    doc = process_erb
    doc.should have_description("h3", "Results from Processor 0")
    doc.should have_fake(:elements, "fake elements 0")
    doc.should have_description("h3", "Results from Processor 1")
    doc.should have_fake(:elements, "fake elements 1")
    doc.should have_description("h3", "Results from Processor 2")
    doc.should have_fake(:elements, "fake elements 2")
  end
  
  def expect_red_or_green(subresult, description, rendered_elements)
    processor, elements = mock('processor'), mock('elements')

    subresult.should_receive(:processor).and_return(processor)
    processor.should_receive(:describe).with().and_return(description)
    subresult.should_receive(:relevant_elements).and_return(elements)
    @recursion.should_receive(:render).
      with("detail_row/elements", :elements => elements).
      and_return(fake(:elements, rendered_elements))
  end
    
  def result
    @result
  end
end
