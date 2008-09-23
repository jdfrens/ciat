require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

module CustomDetailRowMatchers
  class HaveColSpan
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      (@target/"//td").attr('colspan').eql?(@expected.to_s)
    end

    def failure_message
      "expected #{@target.inspect} to have colspan #{@expected}"
    end

    def negative_failure_message
      "expected #{@target.inspect} not to have colspan #{@expected}"
    end
  end
  
  class HaveInnerHtml
    def initialize(xpath, expected)
      @xpath = xpath
      @expected = expected
    end
    
    def matches?(target)
      @target = target
      (@target/@xpath).inner_html.match(@expected)
    end
    
    def failure_message
      "expected #{@target.inspect} to have '#{@expected}' at #{@xpath}"
    end
    
    def negative_failure_message
      "expected #{@target.inspect} not to have source '#{@expected}' at #{@xpath}"
    end
  end
  
  def have_colspan(expected)
    HaveColSpan.new(expected)
  end
  
  def have_inner_html(xpath, expected)
    HaveInnerHtml.new(xpath, expected)
  end
  
  def have_source(expected)
    have_inner_html("//pre[@class=source]", expected)
  end
  
  def have_yellow_result(expected)
    have_inner_html("p.yellow-result", expected)
  end

  def have_unset_result(expected)
    have_inner_html("p.unset-result", expected)
  end
end

describe "detail row of test report" do
  include CustomDetailRowMatchers
  
  before(:each) do
    @result = mock('result')
    @elements = mock('elements')
    @erb = ERB.new(File.read("lib/templates/detail_row.html.erb"))
  end
  
  it "should work with no processors" do
    @result.should_receive(:processors).at_least(:once).and_return([])
    @result.should_receive(:elements).and_return(@elements)
    @elements.should_receive(:[]).with(:source).and_return("the source")
    
    doc = process_erb
    doc.should have_colspan(1)
    doc.should have_source("the source")
  end
  
  it "should work with multiple processors and no checked files" do
    processors = [mock('p 0'), mock('p 1'), mock('p 2')]
    lights = { processors[0] => mock('l 1'), processors[1] => mock('l 2'), processors[2] => mock('l 3')}
    crate = mock('crate')
    
    @result.should_receive(:crate).any_number_of_times.and_return(crate)
    @result.should_receive(:lights).any_number_of_times.and_return(lights)
    @result.should_receive(:processors).any_number_of_times.and_return(processors)
    @result.should_receive(:elements).and_return(@elements)
    @elements.should_receive(:[]).with(:source).and_return("source!!!")
    expect_not_yellow(lights, processors[0], "p 0 description")
    expect_not_yellow(lights, processors[1], "p 1 description")
    expect_not_yellow(lights, processors[2], "p 2 description")
    
    doc = process_erb
    doc.should have_colspan(4)
    doc.should have_source("source!!!")
  end
  
  it "should work with yellow light" do
    processor = mock('processor')
    lights = { processor => mock('light') }
    crate = mock('crate')
    
    @result.should_receive(:crate).any_number_of_times.and_return(crate)
    @result.should_receive(:lights).any_number_of_times.and_return(lights)
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    @result.should_receive(:elements).and_return(@elements)
    @elements.should_receive(:[]).with(:source).and_return("source!!!")
    expect_yellow(lights, processor, "description")
    
    doc = process_erb
    doc.should have_source("source!!!")
    doc.should have_yellow_result("description")
  end
  
  it "should work with unset light" do
    processor = mock('processor')
    lights = { processor => mock('light') }
    crate = mock('crate')
    
    @result.should_receive(:crate).any_number_of_times.and_return(crate)
    @result.should_receive(:lights).any_number_of_times.and_return(lights)
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    @result.should_receive(:elements).and_return(@elements)
    @elements.should_receive(:[]).with(:source).and_return("source!!!")
    expect_unset(lights, processor, "description")
    
    doc = process_erb
    doc.should have_source("source!!!")
    doc.should have_unset_result("description")    
  end

  def expect_not_yellow(lights, processor, description)
    processor.should_receive(:description).and_return(description)
    lights[processor].should_receive(:setting).and_return(:fake_non_yellow)
    processor.should_receive(:checked_files).and_return([])
  end
  
  def expect_yellow(lights, processor, description)
    processor.should_receive(:description).at_least(:once).and_return(description)
    lights[processor].should_receive(:setting).and_return(:yellow)
  end
  
  def expect_unset(lights, processor, description)
    processor.should_receive(:description).at_least(:once).and_return(description)
    lights[processor].should_receive(:setting).and_return(:unset)
  end
  
  def process_erb
    Hpricot(@erb.result(binding))
  end
  
  def result
    @result
  end
  
  def elements
    @elements
  end
  
  def replace_tabs(string)
    string
  end
  
  def light_to_sentence(prefix, light)
    prefix
  end
end
