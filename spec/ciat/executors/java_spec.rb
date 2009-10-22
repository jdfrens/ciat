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
  
  before(:each) do
    @classpath = mock("classpath", :to_s => 'the classpath')
    @interpreter_class = mock("interpreter", :to_s => 'the interpreter')
    @test_file = mock('test file')
    @elements = mock('elements')
    @executor = CIAT::Executors::Java.new(@classpath, @interpreter_class)
  end
  
  it "should have an executable" do
    @executor.executable.should == "java -cp 'the classpath' the interpreter"
  end
  
end
