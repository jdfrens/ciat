begin
  require 'spec'
rescue LoadError
  require 'rubygems'
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

  def render(file, locals)
    @recursion.render(file, locals)
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
  
  def have_source(expected)
    have_inner_html("//pre[@class=source]", expected)
  end
  
  def have_description(expected)
    have_inner_html("//h3", expected)
  end
  
  def have_fake(type, expected)
    have_inner_html("//div[@class=\"fake\"]/div[@id=\"#{type}\"]", expected)
  end
    
  def have_checked_result(expected)
    have_inner_html("table th:first", "Expected")
  end
  
  def have_no_optional_element(element)
  end
  
  def have_optional_element_description(element, expected_description)
    have_inner_html("div.#{element} h3", expected_description)
  end
  
  def have_optional_element_content(element, expected_content)
    have_inner_html("div.#{element} pre", expected_content)
  end
  
  def have_diff_table(n, expected)
    have_inner_html("table:nth(#{n})", /Expected(.|\s)*Generated(.|\s)*#{expected}/)
  end
end
