require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "summary row of test report" do
  include ERBHelpers
  include CustomDetailRowMatchers
  
  attr_reader :erb
  attr_reader :recursion
  
  before(:each) do
    @counter = mock("counter")
    
    @erb = ERB.new(File.read("lib/templates/test_numbers.html.erb"))
  end
  
  it "should just report on the number of tests when no errors or failures" do
    @size = 4
    @counter.stub!(:error_count).and_return(0)
    @counter.stub!(:failure_count).and_return(0)
    
    (process_erb/"p").each do |p|
      (p/".test-count").inner_html.should match("4 tests")
      (p/".green").inner_html.should match("all good")
      (p/".yellow").should be_empty
      (p/".red").should be_empty
    end
  end
  
  it "should report the number of errors" do
    @size = 17
    @counter.should_receive(:error_count).at_least(:once).and_return(8)
    @counter.stub!(:failure_count).and_return(0)
    
    (process_erb/"p").each do |p|
      (p/".test-count").inner_html.should match("17 tests")
      (p/".green").should be_empty
      (p/".yellow").inner_html.should match("8 errors")
      (p/".red").should be_empty
    end
  end

  it "should report the number of failures" do
    @size = 34
    @counter.stub!(:error_count).and_return(0)
    @counter.should_receive(:failure_count).at_least(:once).and_return(14)
    
    (process_erb/"p").each do |p|
      (p/".test-count").inner_html.should match("34 tests")
      (p/".green").should be_empty
      (p/".yellow").should be_empty
      (p/".red").inner_html.should match("14 failures")
    end
  end

  it "should report the number of errors and failures" do
    @size = 44
    @counter.should_receive(:error_count).at_least(:once).and_return(5)
    @counter.should_receive(:failure_count).at_least(:once).and_return(23)
    
    (process_erb/"p").each do |p|
      (p/".test-count").inner_html.should match("44 tests")
      (p/".green").should be_empty
      (p/".yellow").inner_html.should match("5 errors")
      (p/".red").inner_html.should match("23 failures")
    end
  end

  def process_erb
    Hpricot(@erb.result(binding))
  end
  
  def size
    @size
  end
  
  def counter
    @counter
  end
  
end