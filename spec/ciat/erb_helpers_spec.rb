require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::ERBHelpers do
  before(:each) do
    @helper = Object.new
    @helper.extend(CIAT::ERBHelpers)
    
    @unset = CIAT::TrafficLight.new(:unset)
    @green = CIAT::TrafficLight.new(:green)
    @yellow = CIAT::TrafficLight.new(:yellow)
    @red = CIAT::TrafficLight.new(:red)
  end
  
  describe "converting light to word" do
    it "should handle unset light" do
      @helper.light_to_word(@unset).should == "n/a"
    end
    
    it "should handle green light" do
      @helper.light_to_word(@green).should == "passed"
    end

    it "should handle yellow light" do
      @helper.light_to_word(@yellow).should == "ERROR"
    end

    it "should handle red light" do
      @helper.light_to_word(@red).should == "FAILURE"
    end
  end

  describe "converting light to sentence" do
    it "should handle unset light" do
      @helper.light_to_sentence("prefix", @unset).should ==
        "<span class=\"unset\">prefix not run.</span>"
    end
    
    it "should handle green light" do
      @helper.light_to_sentence("prefix", @green).should ==
        "<span class=\"green\">prefix passed.</span>"
    end

    it "should handle yellow light" do
      @helper.light_to_sentence("prefix", @yellow).should ==
        "<span class=\"yellow\">prefix errored.</span>"
    end

    it "should handle red light" do
      @helper.light_to_sentence("prefix", @red).should ==
        "<span class=\"red\">prefix failed.</span>"
    end
  end  
end
