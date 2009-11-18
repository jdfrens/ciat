require 'rubygems'
require 'webrat'

module WebratHelpers  
  def webrat_document(file)
    Webrat::XML.html_document(open(file).readlines)
  end
end

module SpecialCiatHelpers
  def have_element(element)
    have_selector("#details_#{@file} #{element}")
  end
  
  def indicate_happy_path
    have_selector("#details_#{@file} h3", :content => "happy path")
  end
  alias indicate_a_happy_path indicate_happy_path
  
  def indicate_sad_path
    have_selector("#details_#{@file} h3", :content => "sad path")
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
      :source,
      :compilation, :compilation_generated,
      :compilation_error, :compilation_error_generated,
      :compilation_diff, :compilation_error_diff,
      :execution, :execution_generated,
      :execution_error, :execution_error_generated,
      :execution_diff, :execution_error_diff,
      :command_line
    ]
    (all_elements - elements).each do |element|
      it "should not have #{element}" do
        @doc.should_not have_element(element)
      end
    end
  end
end

Spec::Runner.configure do |config|
  config.include(WebratHelpers)
  config.include(SpecialCiatHelpers)
  config.extend(ElementHelpers)
end
