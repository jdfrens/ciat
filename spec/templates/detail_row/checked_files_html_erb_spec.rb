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
  
  it "should process one checked file" do
    @checked_files = [mock("checked")]
    diff = mock("diff")
    
    expect_diff(0, "the diff")
    
    doc = process_erb
    doc.should have_diff_table(0, "the diff")
  end
  
  it "should process many checked files" do
    @checked_files = [mock("a"), mock("b"), mock("c")]
    
    expect_diff(0, "diff a")
    expect_diff(1, "diff b")
    expect_diff(2, "diff c")

    doc = process_erb
    doc.should have_diff_table(0, "diff a")
    doc.should have_diff_table(1, "diff b")
    doc.should have_diff_table(2, "diff c")
  end
  
  def expect_diff(index, contents)
    diff = mock("diff #{index}")
    @checked_files[index].should_receive(:diff).and_return(diff)
    File.should_receive(:read).with(diff).and_return(contents)
  end
end
