require 'rubygems'
begin
  require 'spec'
rescue LoadError
  gem 'rspec'
  require 'spec'
end
require 'webrat'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ciat'

module ERBHelpers
  def build_erb(filename)
    erb = ERB.new(File.read(filename))
    erb.filename = File.expand_path(filename)
    erb
  end
  
  def process_erb
    Webrat::XML.html_document(erb.result(binding))
  end
  
  def replace_tabs(string)
    string
  end
  
  def light_to_sentence(prefix, light)
    prefix
  end
  
  def filename_to_id(filename)
    filename
  end
  
  def title(text)
    text
  end

  def render(file, locals)
    @recursion.render(file, locals)
  end

  def fake(what, content)
    "<div class=\"fake\"><div id=\"#{what}\">#{content}</div></div>"
  end
  
  def fake_selector
    "div.fake"
  end
end

module MockHelpers
  def array_of_mocks(count, name)
    (1..count).to_a.map do |i|
      mock(name + " " + i.to_s)
    end
  end
end

module CustomDetailRowMatchers
  class HaveInnerHtml
    def initialize(xpath, expected)
      @xpath = xpath
      @expected = expected
    end
    
    def matches?(target)
      @target = target
      (@target/@xpath).inner_html.match(@expected)
    end
    
    def failure_message
      "expected #{@target.inspect} to have '#{@expected}' at #{@xpath}"
    end
    
    def negative_failure_message
      "expected #{@target.inspect} not to have source '#{@expected}' at #{@xpath}"
    end
  end
  
  def have_inner_html(xpath, expected)
    HaveInnerHtml.new(xpath, expected)
  end
    
  def have_fake(type, expected)
    have_inner_html("//div[@class=\"fake\"]/div[@id=\"#{type}\"]", expected)
  end
    
  def have_diff_table(expected)
    have_inner_html("table", /Expected(.|\s)*Generated(.|\s)*#{expected}/)
  end
end

Spec::Runner.configure do |config|
  config.include(MockHelpers)
end