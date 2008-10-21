require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'hpricot'

describe "checked-files output in detail row" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :checked_files
  
  before(:each) do
    @erb = ERB.new(File.read("lib/templates/detail_row/checked_files.html.erb"))
  end

  it "should handle no checked files" do
    @checked_files = []
    
    doc = process_erb
  end
  
  it "should process one checked file"
  
  it "should process many checked files"
end
