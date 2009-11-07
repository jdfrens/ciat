require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'
require 'webrat'

describe "summary row of test report" do
  include ERBHelpers
  include CustomDetailRowMatchers
  include Webrat::Matchers
  
  attr_reader :erb
  attr_reader :recursion
  
  before(:each) do
    @result = mock('result')
    @result.stub!(:filename).and_return("the filename")
    @recursion = mock('recursion')
    @erb = build_erb("lib/templates/summary_row.html.erb")
  end
  
  it "should work with no processors" do
    expect_description("the description")
    @result.should_receive(:subresults).at_least(:once).and_return([])
    
    process_erb.should have_selector("body") do |body|
      body.should have_selector("a", :content => "the description")
      body.should have_selector("td", :count => 1)
    end
  end

  it "should work with one processor" do
    subresult, light = mock("subresult"), mock("light")
  
    expect_description("one proc description")
    @result.should_receive(:subresults).
      at_least(:once).and_return([subresult])
    
    expect_light(subresult, :light_setting, "the light")
  
    doc = process_erb
    doc.should have_selector("body") do |body|
      body.should have_selector("a", :content => "one proc description")
      body.should have_selector(".light_setting", :content => "the light")
      body.should have_selector("td", :count => 2)      
    end
  end
  
  it "should work with many processors" do
    subresults = [mock("subresult 0"), mock("subresult 1"), mock("subresult 2")]
  
    expect_description("description three")
    @result.should_receive(:subresults).at_least(:once).and_return(subresults)
    
    expect_light(subresults[0], :light0, "word 0")
    expect_light(subresults[1], :light1, "word 1")
    expect_light(subresults[2], :light2, "word 2")
  
    process_erb.should have_selector("body") do |body|
      body.should have_selector("a", :content => "description three")
      body.should have_light(:light0, "word 0")
      body.should have_light(:light1, "word 1")
      body.should have_light(:light2, "word 2")
      body.should have_selector("td", :count => 4)
    end
  end
  
  def expect_light(subresult, setting, word)
    light = mock("mock #{setting}")
    subresult.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:setting).and_return(setting)
    light.should_receive(:text).and_return(word)
  end
      
  def expect_description(text)
    description = mock("description")
    @result.should_receive(:element).
      with(:description).and_return(description)
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
