# If it were easy for you to write your own HTML templates, then the methods
# in this module would be useful.
#
# <em>I don't know if it's easy to write your own HTML template!</em>
module CIAT::ERBHelpers
  # Turns a traffic light into a more "testing" word: "FAILURE",
  # "ERROR", "passed", "n/a".
  def light_to_word(light)
  	case
  	when light.red? then "FAILURE"
  	when light.yellow? then "ERROR"
  	when light.green? then "passed"
  	when light.unset? then "n/a"
  	when light.unneeded? then "unneeded"
	  else
	    raise "cannot turn #{light} into word"
  	end
  end

  # Turns a traffic light in a sentence wrapped in a classed +span+.
  def light_to_sentence(prefix, light)
  	"<span class=\"#{light.color}\">#{prefix} " +
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
  
  def filename_to_id(filename)
    filename.gsub(/[\/\-.]/, "_")
  end

  # Capitalizes string as a title.
  def title(text)
    text.gsub(/\b\w/){$&.upcase}
  end
  
  # Replaces tabs with spaces because Firefox does _really_ wacky things with
  # tabs in a +pre+ in a +table+.
  def replace_tabs(string)
  	string.gsub("\t", "    ")
  end
  
  def new_grouping?(result)
    if @old_grouping == result.grouping
      false
    else
      @old_grouping = result.grouping
      true
    end
  end
  
  # Recursively renders another template.  If it's possible to write your own
  # templates for reports, this will probably play a key role.
  def render(file, locals)
    erb = ERB.new(read(file))
    erb.filename = file
    erb.result(CIAT::TemplateBinder.new(locals).get_binding)
  end
  
  private
  
  def read(file)
    File.read(template_path(file))
  end
  
  def template_path(file)
    File.join(File.dirname(__FILE__), '..', 'templates', file + ".html.erb")
  end
end

# Assists in binding local variables for a recursive render.
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
