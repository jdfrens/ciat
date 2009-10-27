require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/parrot'

describe CIAT::Executors::Parrot do
  describe "mixins" do
    it "should use basic processing module" do
      CIAT::Executors::Parrot.should include(CIAT::Processors::BasicProcessing)
    end

    it "should use basic processing module" do
      CIAT::Executors::Parrot.should include(CIAT::Differs::HtmlDiffer)
    end
  end
  
  describe "default executor" do
    before(:each) do
      @executor = CIAT::Executors::Parrot.new
    end

    it "should have an executable" do
      @executor.executable.should == "parrot"
    end
  end
  
  it "should have settable options" do
    CIAT::Executors::Parrot.new do |executor|
      executor.kind = mock("processor kind")
      executor.description = mock("description")
      executor.libraries = mock("libraries")
    end
  end
  
  it "should use system libraries" do
    executor = CIAT::Executors::Parrot.new do |e|
      e.libraries = ["/usr/local/foo", "../bar"]
    end
    executor.executable.should == "parrot -L/usr/local/foo -L../bar"
  end
end
