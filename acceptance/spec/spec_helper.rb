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
  
  def indicate_sad_path
    have_selector("#details_#{@file} h3", :content => "sad path")
  end
end

Spec::Runner.configure do |config|
  config.include(WebratHelpers)
  config.include(SpecialCiatHelpers)
end
