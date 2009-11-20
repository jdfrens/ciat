require 'rubygems'
require 'webrat'

module WebratHelpers
  def parse_document
    file = "temp/#{folder.join("-")}.html"
    @doc = Nokogiri::HTML.parse(open(file).read) 
  end
end

module SpecialCiatHelpers
  def details_id
    (["details", "ciat"] + @folder + [@path_kind, "ciat"]).join("_")
  end
  
  def have_element(element)
    have_selector("##{details_id} .#{element}")
  end
  
  def indicate_happy_path
    have_selector("##{details_id} h3", :content => "happy path")
  end
  alias indicate_a_happy_path indicate_happy_path
  
  def indicate_sad_path
    have_selector("##{details_id} h3", :content => "sad path")
  end
  alias indicate_a_sad_path indicate_sad_path
end

module ElementHelpers  
  def it_should_have_only_the_elements(*elements)
    elements.each do |element|
      it "should have #{element}" do
        @doc.should have_element(element)
      end
    end
    
    all_elements = [
      "source",
      "compilation", "compilation_generated",
      "compilation_error", "compilation_error_generated",
      "compilation_diff", "compilation_error_diff",
      "execution", "execution_generated",
      "execution_error", "execution_error_generated",
      "execution_diff", "execution_error_diff",
      "command_line"
    ]
    (all_elements - elements).each do |element|
      it "should not have #{element}" do
        @doc.should_not have_element(element)
      end
    end
  end
  
  def it_should_indicate_a_happy_path
    it "should indicate a happy path" do
      @doc.should indicate_happy_path
    end
  end

  def it_should_indicate_a_sad_path
    it "should indicate a sad path" do
      @doc.should indicate_sad_path
    end
  end

  def happy_path(*modifiers)
    before(:each) do
      @path_kind = (["happy"] + modifiers).join("_")
    end
  end

  def sad_path
    before(:each) do
      @path_kind = "sad"
    end
  end
  
  def folder(*components)
    before(:each) do
      @folder = components
      file = "temp/#{components.join("-")}.html"
      @doc = Nokogiri::HTML.parse(open(file).read) 
    end
  end
end

Spec::Runner.configure do |config|
  config.include(WebratHelpers)
  config.include(SpecialCiatHelpers)
  config.extend(ElementHelpers)
end
