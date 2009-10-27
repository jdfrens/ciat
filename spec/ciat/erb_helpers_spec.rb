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
  
  it "should render another template" do
    template = mock("template")
    locals = mock("locals")
    binder = mock("binder")
    bindings = mock("bindings")
    erb = mock("erb")
    result = mock("result")

    @helper.should_receive(:read).with("phile.html.erb").and_return(template)
    ERB.should_receive(:new).with(template).and_return(erb)
    CIAT::TemplateBinder.should_receive(:new).with(locals).and_return(binder)
    binder.should_receive(:get_binding).and_return(bindings)
    erb.should_receive(:filename=).with("phile.html.erb")
    erb.should_receive(:result).with(bindings).and_return(result)
    
    @helper.render("phile.html.erb", locals).should == result
  end
end
