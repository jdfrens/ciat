module WebratHelpers  
  def webrat_document(file)
    Webrat::XML.html_document(open(file).readlines)
  end
end

Spec::Runner.configure do |config|
  config.include(WebratHelpers)
end
