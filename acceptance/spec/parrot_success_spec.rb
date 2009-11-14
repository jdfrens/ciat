require 'spec_helper'

describe "parrot-success.html" do
  include Webrat::Matchers
  
  before(:each) do
    @doc = webrat_document("temp/parrot-success.html")
  end

  describe "the success of a happy path" do
    before(:each) do
      @file = "ciat_parrot_success_command_line_ciat"
    end
    
    it "should have the appropriate elements" do
      @doc.should have_selector("#details_#{@file} .execution_generated")
      @doc.should_not have_selector("#details_#{@file} .execution_error_generated")
    end

    it "should describe a happy path" do
      @doc.should have_selector("#details_ciat_parrot_success_command_line_ciat") do |row|
        row.should have_selector("h3", :content => "happy path")
      end
    end
  end
end