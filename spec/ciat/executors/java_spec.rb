require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/executors/java'

describe CIAT::Executors::Java do
  describe "mixins" do
    it "should use basic processing module" do
      CIAT::Executors::Java.should include(CIAT::Processors::BasicProcessing)
    end

    it "should use HTML differ" do
      CIAT::Executors::Java.should include(CIAT::Differs::HtmlDiffer)
    end
  end

  it "should have settable options" do
    CIAT::Executors::Java.new(mock("classpath"), mock("interpreter class")) do |executor|
      executor.kind = mock("processor kind")
      executor.description = mock("description")
      executor.light = mock("light")
    end
  end
  it "should have an executable" do
    @classpath = mock("classpath", :to_s => 'the classpath')
    @interpreter_class = mock("interpreter", :to_s => 'the interpreter')
    
    @executor = CIAT::Executors::Java.new(@classpath, @interpreter_class)
    @executor.executable.should == "java -cp 'the classpath' the interpreter"
  end
  
end
