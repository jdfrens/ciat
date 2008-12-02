require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'hpricot'

describe "report" do
  include ERBHelpers
  
  before(:each) do
    @elements = mock("elements")
    @recursion = mock("recursion")
    
    @processors = []
    @results = []
    @erb = ERB.new(CIAT::Suite.template)
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
      
      @recursion.should_receive(:render).with("summary_row", :result => @results[0])
      @recursion.should_receive(:render).with("summary_row", :result => @results[1])
      @recursion.should_receive(:render).with("summary_row", :result => @results[2])
      @recursion.should_receive(:render).with("detail_row", :result => @results[0])
      @recursion.should_receive(:render).with("detail_row", :result => @results[1])
      @recursion.should_receive(:render).with("detail_row", :result => @results[2])
      
      process_erb
    end
  end
  
  def process_erb
    Hpricot(@erb.result(binding))
  end
  
  def processors
    @processors
  end
  
  def results
    @results
  end
  
  # def render(file, result)
  #   @recursion.render(file, result)
  # end
end
