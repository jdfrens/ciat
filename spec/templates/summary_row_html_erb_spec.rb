require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "summary row of test report" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :recursion
  
  before(:each) do
    @result = mock('result')
    @result.stub!(:filename).and_return("the filename")
    @recursion = mock('recursion')
    @erb = ERB.new(File.read("lib/templates/summary_row.html.erb"))
  end
  
  it "should work with no processors" do
    expect_description("the description")
    @result.should_receive(:processors).at_least(:once).and_return([])
    
    doc = process_erb
    doc.should have_description("the description")
    doc.should have_none("/tr/td[2]")
  end

  it "should work with one processor" do
    processor, light = mock("processor"), mock("light")
  
    expect_description("one proc description")
    @result.should_receive(:processors).at_least(:once).and_return([processor])
    
    expect_light(processor, :light_setting, "the light")
  
    doc = process_erb
    doc.should have_description("one proc description")
    doc.should have_light(:light_setting, "the light")
    doc.should have_none("/tr/td[3]")
  end
  
  it "should work with many processors" do
    processors = [mock("processor 0"), mock("processor 1"), mock("processor 2")]
  
    expect_description("description three")
    @result.should_receive(:processors).at_least(:once).and_return(processors)
    
    expect_light(processors[0], :light0, "word 0")
    expect_light(processors[1], :light1, "word 1")
    expect_light(processors[2], :light2, "word 2")
  
    doc = process_erb
    doc.should have_description("description three")
    doc.should have_light(:light0, "word 0")
    doc.should have_light(:light1, "word 1")
    doc.should have_light(:light2, "word 2")
    doc.should have_none("/tr/td[5]")
  end
  
  def expect_light(processor, setting, word)
    light = mock("mock #{setting}")
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:setting).and_return(setting)
    light.should_receive(:text).and_return(word)
  end
      
  def expect_description(text)
    description = mock("description")
    @result.should_receive(:element).with(:description).and_return(description)
    description.should_receive(:content).and_return(text)
  end
  
  def fake(what, content)
    "<div class=\"fake\"><div id=\"#{what}\">#{content}</div></div>"
  end
  
  def have_light(css_class, light)
    have_inner_html(".#{css_class}", light)
  end
  
  def have_description(expected)
    have_inner_html("/tr/td[1]/a", expected)
  end
  
  def light_to_word(light)
    light.text
  end
  
  def result
    @result
  end
end
