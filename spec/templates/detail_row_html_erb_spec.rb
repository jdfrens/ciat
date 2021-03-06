require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "detail row of test report" do
  include ERBHelpers
  include CustomDetailRowMatchers
  include Webrat::Matchers
  
  attr_reader :erb
  attr_reader :recursion
  
  before(:each) do
    @result = mock('result')
    @result.should_receive(:filename).and_return("foo/bar/filename.ciat")
    @ciat_file = mock('ciat file')
    @recursion = mock('recursion')
    @erb = build_erb("lib/templates/detail_row.html.erb")
  end
  
  it "should work with no subresults" do
    @result.should_receive(:subresults).at_least(:once).and_return([])
    
    process_erb.should have_selector("td", :colspan => "1")
  end

  it "should work with one processor" do
    subresult = mock('subresult')
    
    @result.should_receive(:subresults).
      any_number_of_times.and_return([subresult])
    expect_set_and_needed_processor(subresult, "The Processor", :happy, "fake elements")

    process_erb.should have_selector("body") do |body|
      body.should have_selector("h3", :content => "Results from The Processor")
      body.should have_fake(:elements, "fake elements")
    end
  end
  
  it "should work with many processors with all success" do
    subresults = array_of_mocks(3, "subresult")
    
    @result.should_receive(:subresults).
      any_number_of_times.and_return(subresults)
    expect_set_and_needed_processor(subresults[0], "Processor 0", :happy, "fake elements 0")
    expect_set_and_needed_processor(subresults[1], "Processor 1", :happy, "fake elements 1")
    expect_set_and_needed_processor(subresults[2], "Processor 2", :sad, "fake elements 2")

    process_erb.should have_selector("body") do |body|
      body.should have_selector("h3", :content => "Results from Processor 0 (happy path)")
      body.should have_fake(:elements, "fake elements 0")
      body.should have_selector("h3", :content => "Results from Processor 1 (happy path)")
      body.should have_fake(:elements, "fake elements 1")
      body.should have_selector("h3", :content => "Results from Processor 2 (sad path)")
      body.should have_fake(:elements, "fake elements 2")
    end
  end
  
  it "should work with many processors with some success and some unset" do
    subresults = array_of_mocks(3, "subresult")
    
    @result.should_receive(:subresults).
      any_number_of_times.and_return(subresults)
    expect_set_and_needed_processor(subresults[0], "Processor 0", :happy, "fake elements 0")
    expect_set_and_needed_processor(subresults[1], "Processor 1", :happy, "fake elements 1")
    expect_unset_processor(subresults[2], "Processor 2", :happy)

    process_erb.should have_selector("body") do |body|
      body.should have_selector("h3", :content => "Results from Processor 0 (happy path)")
      body.should have_fake(:elements, "fake elements 0")
      body.should have_selector("h3", :content => "Results from Processor 1 (happy path)")
      body.should have_fake(:elements, "fake elements 1")
      body.should have_selector("h3", :content => "Results from Processor 2 (happy path)")
      body.should have_selector("p", :content => "Not executed.")
    end
  end
  
  it "should work with many processors with some success and some unneeded" do
    subresults = array_of_mocks(3, "subresult")
    
    @result.should_receive(:subresults).
      any_number_of_times.and_return(subresults)
    expect_set_and_needed_processor(subresults[0], "Processor 0", :happy, "fake elements 0")
    expect_set_and_needed_processor(subresults[1], "Processor 1", :happy, "fake elements 1")
    expect_unneeded_processor(subresults[2], "Processor 2", :happy)

    process_erb.should have_selector("body") do |body|
      body.should have_selector("h3", :content => "Results from Processor 0 (happy path)")
      body.should have_fake(:elements, "fake elements 0")
      body.should have_selector("h3", :content => "Results from Processor 1 (happy path)")
      body.should have_fake(:elements, "fake elements 1")
      body.should have_selector("h3", :content => "Results from Processor 2 (happy path)")
      body.should have_selector("p", :content => "Not executed.")
    end
  end
  
  def expect_set_and_needed_processor(subresult, description, path_kind, rendered_elements)
    processor, elements = mock('processor'), mock('elements')

    subresult.should_receive(:processor).and_return(processor)
    processor.should_receive(:describe).with().and_return(description)
    subresult.stub_chain(:light, :unset?).and_return(false)
    subresult.stub_chain(:light, :unneeded?).and_return(false)
    subresult.should_receive(:path_kind).and_return(path_kind)
    subresult.should_receive(:relevant_elements).and_return(elements)
    @recursion.should_receive(:render).
      with("detail_row/elements", :elements => elements).
      and_return(fake(:elements, rendered_elements))
  end
    
  def expect_unset_processor(subresult, description, path_kind)
    processor, elements = mock('processor'), mock('elements')

    subresult.should_receive(:processor).and_return(processor)
    processor.should_receive(:describe).with().and_return(description)
    subresult.stub_chain(:light, :unset?).and_return(true)
    subresult.stub_chain(:light, :unneeded?).and_return(false)
    subresult.should_receive(:path_kind).and_return(path_kind)
  end
    
  def expect_unneeded_processor(subresult, description, path_kind)
    processor, elements = mock('processor'), mock('elements')

    subresult.should_receive(:processor).and_return(processor)
    processor.should_receive(:describe).with().and_return(description)
    subresult.stub_chain(:light, :unset?).and_return(false)
    subresult.stub_chain(:light, :unneeded?).and_return(true)
    subresult.should_receive(:path_kind).and_return(path_kind)
  end
    
  def result
    @result
  end
end
