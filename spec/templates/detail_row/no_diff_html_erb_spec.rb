require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "source output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  
  before(:each) do
    @processor = mock('processor')
    @erb = ERB.new(File.read("lib/templates/detail_row/no_diff.html.erb"))
  end

  it "should display a sentence" do
    light = mock("light")
    
    @processor.should_receive(:light).at_least(:once).and_return(light)
    light.should_receive(:setting).and_return(:the_setting)
    @processor.should_receive(:description).and_return("the sentence")
    
    doc = process_erb
    doc.should have_inner_html("p.the_setting", "\n  the sentence\n")
  end
    
  def processor
    @processor
  end
end
