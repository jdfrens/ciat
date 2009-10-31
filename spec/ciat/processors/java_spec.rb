require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/processors/java'

describe CIAT::Processors::Java do
  describe "mixins" do
    it "should use basic processing module" do
      CIAT::Processors::Java.should include(CIAT::Processors::BasicProcessing)
    end

    it "should use HTML differ" do
      CIAT::Processors::Java.should include(CIAT::Differs::HtmlDiffer)
    end
  end

  it "should have settable options" do
    CIAT::Processors::Java.new(mock("classpath"), mock("interpreter class")) do |executor|
      executor.kind = mock("processor kind")
      executor.description = mock("description")
    end
  end
  
  it "should have an executable" do
    @classpath = mock("classpath", :to_s => 'the classpath')
    @interpreter_class = mock("interpreter", :to_s => 'the interpreter')
    
    @processor = CIAT::Processors::Java.new(@classpath, @interpreter_class)
    @processor.executable.should == "java -cp 'the classpath' the interpreter"
  end
  
end
