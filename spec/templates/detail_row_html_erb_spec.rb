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
    have_inner_html("p.yellow", expected)
  end

  def have_unset_result(expected)
    have_inner_html("p.unset", expected)
  end
  
  def have_checked_result(expected)
    have_inner_html("table th:first", "Expected")
  end
  
  def have_optional_element(element, expected_description, expected_content)
    have_inner_html("div##{element} h3", expected_description)
  end
  
  def have_diff_table(n, expected)
    have_inner_html("table:nth(#{n})", /Expected(.|\s)*Generated(.|\s)*#{expected}/)
  end
end

describe "detail row of test report" do
  include CustomDetailRowMatchers
  
  before(:each) do
    @result = mock('result')
    @crate = mock('crate')
    @erb = ERB.new(File.read("lib/templates/detail_row.html.erb"))

    @result.should_receive(:crate).any_number_of_times.and_return(@crate)
  end
  
  it "should work with no processors" do
    @result.should_receive(:processors).at_least(:once).and_return([])
    @crate.should_receive(:element).with(:source).and_return("the source")
    
    doc = process_erb
    doc.should have_colspan(1)
    doc.should have_source("the source")
  end
  
  it "should work with multiple processors and no checked files" do
    processors = [mock('p 0'), mock('p 1'), mock('p 2')]
    lights = [mock('l 1'), mock('l 2'), mock('l 3')]
    
    @result.should_receive(:lights).any_number_of_times.and_return(lights)
    @result.should_receive(:processors).any_number_of_times.and_return(processors)
    @crate.should_receive(:element).with(:source).and_return("source!!!")
    expect_red_or_green(processors[0], "p 0 description")
    expect_red_or_green(processors[1], "p 1 description")
    expect_red_or_green(processors[2], "p 2 description")
    
    doc = process_erb
    doc.should have_colspan(4)
    doc.should have_source("source!!!")
  end
  
  it "should work with yellow light" do
    processor = mock('processor')
    light = mock('light')
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    @crate.should_receive(:element).with(:source).and_return("source!!!")
    expect_yellow(processor, "description")
    
    doc = process_erb
    doc.should have_source("source!!!")
    doc.should have_yellow_result("description")
  end
  
  it "should work with unset light" do
    processor = mock('processor')
    light = mock('light')
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    @crate.should_receive(:element).with(:source).and_return("source!!!")
    expect_unset(processor, "description")
    
    doc = process_erb
    doc.should have_source("source!!!")
    doc.should have_unset_result("description")    
  end
  
  it "should work with red or green light and multiple checked files" do
    processor = mock('processor')
    light = mock('light')
    checked_files = [
      [mock('expected 0'), mock('generated 0'), mock('diff 0')],
      [mock('expected 1'), mock('generated 1'), mock('diff 1')],
      [mock('expected 2'), mock('generated 2'), mock('diff 2')]
      ]
    
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    @crate.should_receive(:element).with(:source).and_return("source!!!")
    expect_red_or_green(processor, "description", checked_files)
    File.should_receive(:read).with(checked_files[0][2]).and_return("diff contents 0")
    File.should_receive(:read).with(checked_files[1][2]).and_return("diff contents 1")
    File.should_receive(:read).with(checked_files[2][2]).and_return("diff contents 2")
    
    doc = process_erb
    doc.should have_source("source!!!")
    doc.should have_checked_result("description")
    doc.should have_diff_table(0, "diff contents 0")
    doc.should have_diff_table(1, "diff contents 1")
    doc.should have_diff_table(2, "diff contents 2")
  end
  
  it "should work with red or green light and optional elements" do
    processor = mock('processor')
    light = mock('light')
    checked_files = [[mock('expected'), mock('generated'), mock('diff')]]
  
    @result.should_receive(:processors).any_number_of_times.and_return([processor])
    @crate.should_receive(:element).with(:source).and_return("source!!!")
    expect_red_or_green(processor, "description", checked_files, [:optional0, :optional1])
    expect_optional_element(processor, :optional0, "description of optional 0", "content of optional 0")
    expect_optional_element(processor, :optional1, "description of optional 1", "content of optional 1")
    File.should_receive(:read).with(checked_files[0][2]).and_return("diff contents")
  
    doc = process_erb
    doc.should have_source("source!!!")
    doc.should have_optional_element(:optional0, "description of optional 0", "content of optional 0")
    doc.should have_optional_element(:optional1, "description of optional 1", "content of optional 1")
    doc.should have_checked_result("description")
    doc.should have_diff_table(0, "diff contents")
  end

  def expect_optional_element(processor, element, description, contents)
    processor.should_receive(:description).with(element).and_return(description)
    @crate.should_receive(:element).with(element).at_least(:once).and_return(contents)
  end
  
  def expect_red_or_green(processor, description, checked_files=[], optional_elements=[])
    light = mock('red or green light')
    processor.should_receive(:description).with().and_return(description)
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:setting).and_return(:red_or_green)
    processor.should_receive(:optional_elements).and_return(optional_elements)
    processor.should_receive(:checked_files).and_return(checked_files)
  end
  
  def expect_yellow(processor, description)
    light = mock('yellow')
    processor.should_receive(:description).at_least(:once).and_return(description)
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:setting).and_return(:yellow)
  end
  
  def expect_unset(processor, description)
    light = mock('unset')
    processor.should_receive(:description).at_least(:once).and_return(description)
    processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:setting).and_return(:unset)
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
