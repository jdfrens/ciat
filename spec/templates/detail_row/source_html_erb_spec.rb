require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "source output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  
  before(:each) do
    @erb = ERB.new(File.read("lib/templates/detail_row/source.html.erb"))
  end
  
  it "should display the source" do
    @source = "the source"
    
    doc = process_erb
    doc.should have_source("the source")
  end
  
  it "should display different source" do
    @source = "different source"
    
    doc = process_erb
    doc.should have_source("different source")
  end

  def source
    @source
  end
end
