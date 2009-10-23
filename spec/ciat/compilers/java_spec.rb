require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'ciat/compilers/java'

describe CIAT::Compilers::Java do
  describe "mixins" do
    it "should use basic processing module" do
      CIAT::Compilers::Java.should include(CIAT::Processors::BasicProcessing)
    end

    it "should use basic processing module" do
      CIAT::Compilers::Java.should include(CIAT::Differs::HtmlDiffer)
    end
  end
  
  it "should have settable options" do
    CIAT::Compilers::Java.new(mock("classpath"), mock("compiler class")) do |compiler|
      compiler.kind = mock("processor kind")
      compiler.description = mock("description")
      compiler.light = mock("light")
    end
  end
  
  it "should have an executable" do
    @test_file = mock('test file')
    @classpath = mock("classpath")
    @compiler_class = mock("compiler class")
    @compiler = CIAT::Compilers::Java.new(@classpath, @compiler_class)

    @compiler.executable.should == 
      "java -cp '#{@classpath}' #{@compiler_class}"
  end
end
