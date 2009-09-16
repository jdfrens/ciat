require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "report" do
  include ERBHelpers
  
  before(:each) do
    @elements = mock("elements")
    @recursion = mock("recursion")
    
    @processors = []
    @results = []
    @report_title = "CIAT Report"
    @counter = mock("counter")
    @size = mock("size")
    
    @recursion.stub!(:render).with("test_numbers", :counter => @counter, :size => @size)
    
    @erb = ERB.new(File.read("lib/templates/report.html.erb"))
  end
  
  it "should have test numbers" do
    @recursion.should_receive(:render).
      with("test_numbers", :counter => @counter, :size => @size).
      and_return("<h6>The Test Numbers</h6>")
    
    (process_erb/"h6").inner_text.should == "The Test Numbers"    
  end
  
  describe "writing table header" do
    it "should work with no processors" do
      @processors = []
      
      (process_erb/"tr#header th").inner_text.should == "Description"
    end
    
    it "should work with several processors" do
      @processors = [mock("p 0"), mock("p 1"), mock("p 2")]
      
      @processors[0].should_receive(:describe).and_return("d0")
      @processors[1].should_receive(:describe).and_return("d1")
      @processors[2].should_receive(:describe).and_return("d2")
    
      (process_erb/"tr#header th").inner_text.should == "Description" + "d0" + "d1" + "d2"
    end
  end
  
  describe "writing table rows" do
    it "should write summary rows" do
      @results = [mock("r 0"), mock("r 1"), mock("r 2")]
      
      @recursion.should_receive(:render).
        with("summary_row", :result => @results[0])
      @recursion.should_receive(:render).
        with("summary_row", :result => @results[1])
      @recursion.should_receive(:render).
        with("summary_row", :result => @results[2])
      @recursion.should_receive(:render).
        with("detail_row", :result => @results[0])
      @recursion.should_receive(:render).
        with("detail_row", :result => @results[1])
      @recursion.should_receive(:render).
        with("detail_row", :result => @results[2])
      
      process_erb
    end
  end
  
  def process_erb
    Hpricot(@erb.result(binding))
  end
  
  attr_reader :processors
  attr_reader :results
  attr_reader :report_title
  attr_reader :counter
  attr_reader :size

end
