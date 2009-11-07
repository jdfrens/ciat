require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "checked-files output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  include Webrat::Matchers
  
  attr_reader :erb
  attr_reader :element
  
  before(:each) do
    @erb = ERB.new(File.read("lib/templates/elements/diff.html.erb"))
  end

  it "should process one checked file" do
    @element = mock("element")
    
    @element.should_receive(:name).and_return(:element)
    @element.should_receive(:filename).and_return("the filename")
    @element.should_receive(:describe).at_least(:once).and_return("the description")
    @element.should_receive(:content).and_return("the diff")
    
    process_erb.should have_selector("body") do |body|
      body.should have_selector("h4", :content => "the description")
      body.should have_diff_table("the diff")
    end
  end
end
