require File.dirname(__FILE__) + '/../spec_helper'

describe CIAT::SuiteBuilder do
  before(:each) do
    @default_builder = CIAT::SuiteBuilder.new({})
  end
  
  it "should build default feedback" do
    @default_builder.build_feedback.
      should be_an_instance_of(CIAT::Feedback::Composite)
  end
end
