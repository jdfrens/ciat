require 'rubygems'
begin
  require 'spec'
rescue LoadError
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ciat'

module ERBHelpers
  def process_erb
    Hpricot(erb.result(binding))
  end
  
  def replace_tabs(string)
    string
  end
  
  def light_to_sentence(prefix, light)
    prefix
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
end

module CustomDetailRowMatchers
  class HaveColSpan
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      (@target/"//td").attr('colspan').eql?(@expected.to_s)
    end

    def failure_message
      "expected #{@target.inspect} to have colspan #{@expected}"
    end
  
    def negative_failure_message
      "expected #{@target.inspect} not to have colspan #{@expected}"
    end
  end
  
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
  
  class HaveNone
    def initialize(xpath)
      @xpath = xpath
    end
    
    def matches?(target)
      @target = target
      (@target/@xpath).size == 0
    end
    
    def failure_message
      "expected #{@target.inspect} to have nothing with #{@xpath}"
    end
    
    def negative_failure_message
      "expected #{@target.inspect} to have something with #{@xpath}"
    end
  end
  
  def have_colspan(expected)
    HaveColSpan.new(expected)
  end
  
  def have_inner_html(xpath, expected)
    HaveInnerHtml.new(xpath, expected)
  end
  
  def have_none(xpath)
    HaveNone.new(xpath)
  end
  
  def have_description(header, expected)
    have_inner_html("//#{header}", expected)
  end
  
  def have_fake(type, expected)
    have_inner_html("//div[@class=\"fake\"]/div[@id=\"#{type}\"]", expected)
  end
    
  def have_diff_table(expected)
    have_inner_html("table", /Expected(.|\s)*Generated(.|\s)*#{expected}/)
  end
end
