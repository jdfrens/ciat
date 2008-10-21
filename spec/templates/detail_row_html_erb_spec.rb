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
    fake_source("the source")
    
    doc = process_erb
    doc.should have_colspan(1)
    doc.should have_fake(:source, "the source")
  end

  it "should work with yellow light" do
    processor = mock('processor')
    light = mock('light')
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    fake_source("source!!!")
    expect_yellow(processor, "processor description", "yellow result")
    
    doc = process_erb
    doc.should have_fake(:source, "source!!!")
    doc.should have_description("processor description")
    doc.should have_fake(:yellow, "yellow result")
  end
  
  it "should work with unset light" do
    processor = mock('processor')
    light = mock('light')
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    fake_source("source!!!")
    expect_unset(processor, "processor description", "unset result")
    
    doc = process_erb
    doc.should have_fake(:source, "source!!!")
    doc.should have_description("processor description")
    doc.should have_fake(:unset, "unset result")
  end
  
  it "should work with red or green light" do
    processor = mock('processor')
    light = mock('light')
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    fake_source("source!!!")
    expect_red_or_green(processor, "description")

    doc = process_erb
    doc.should have_fake(:source, "source!!!")
    doc.should have_fake(:optional_elements, "fake optional elements")
    doc.should have_fake(:checked_files, "fake checked files")
  end
  
  def expect_red_or_green(processor, description)
    light = mock('red or green light')
    optional_elements = mock('optional elements')
    checked_files = mock('checked files')

    processor.should_receive(:description).with().and_return(description)
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:yellow?).at_least(:once).and_return(false)
    light.should_receive(:unset?).at_least(:once).and_return(false)
    processor.should_receive(:optional_elements).and_return(optional_elements)
    @recursion.should_receive(:render).
      with("detail_row/optional_elements",
       :optional_elements => optional_elements, :processor => processor, :crate => @crate).
      and_return(fake(:optional_elements, "fake optional elements"))
    processor.should_receive(:checked_files).and_return(checked_files)
    @recursion.should_receive(:render).
      with("detail_row/checked_files", :checked_files => checked_files).
      and_return(fake(:checked_files, "fake checked files"))
  end
  
  def expect_yellow(processor, description, result)
    light = mock('yellow')
    processor.should_receive(:description).at_least(:once).and_return(description)
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:yellow?).at_least(:once).and_return(true)
    light.should_receive(:unset?).any_number_of_times.and_return(false)
    @recursion.should_receive(:render).with("detail_row/no_diff", :processor => processor).
      and_return(fake(:yellow, result))
  end
  
  def expect_unset(processor, description, result)
    light = mock('unset')
    processor.should_receive(:description).at_least(:once).and_return(description)
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:yellow?).any_number_of_times.and_return(false)
    light.should_receive(:unset?).at_least(:once).and_return(true)
    @recursion.should_receive(:render).with("detail_row/no_diff", :processor => processor).
      and_return(fake(:unset, result))
  end
  
  def fake_source(source)
    @crate.should_receive(:element).with(:source).and_return(source)
    @recursion.should_receive(:render).with("detail_row/source", :source => source).
      and_return(fake(:source, source))
  end
  
  def fake(what, content)
    "<div class=\"fake\"><div id=\"#{what}\">#{content}</div></div>"
  end
  
  def result
    @result
  end
end
