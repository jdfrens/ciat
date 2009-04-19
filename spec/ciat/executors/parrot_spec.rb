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
  
  before(:each) do
    @crate = mock('crate')
    @elements = mock('elements')
    @executor = CIAT::Executors::Parrot.new
  end

  it "should have an executable" do
    @executor.executable.should == "parrot"
  end  
end
