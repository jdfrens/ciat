module CIAT::ERBHelpers
  def light_to_word(light)
  	case
  	when light.red? then "FAILURE"
  	when light.yellow? then "ERROR"
  	when light.green? then "passed"
  	when light.unset? then "n/a"
	  else
	    raise "cannot turn #{light} into word"
  	end
  end
  
  def light_to_sentence(prefix, light)
  	"<span class=\"#{light.setting}\">#{prefix} " +
  	case
  	when light.red? then "failed"
  	when light.yellow? then "errored"
  	when light.green? then "passed"
  	when light.unset? then "not run"
	  else
	    raise "cannot turn #{light} into a sentence"
  	end +
  	".</span>"
  end
  
  def replace_tabs(string)
  	string.gsub("\t", "    ")
  end
  
  def render(file, locals)
    ERB.new(read(file)).result(CIAT::TemplateBinder.new(locals).get_binding)
  end
  
  private
  
  def read(file)
    File.read(template_path(file))
  end
  
  def template_path(file)
    File.join(File.dirname(__FILE__), '..', 'templates', file + ".html.erb")
  end
end

class CIAT::TemplateBinder
  include CIAT::ERBHelpers
  
  def initialize(locals)
    locals.each do |variable, value|
      self.class.send(:define_method, variable, Proc.new {value})
    end
  end
  
  def get_binding
    binding
  end
end
