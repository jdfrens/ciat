class CIAT::Subresult
  attr_reader :light
  attr_reader :path_kind
  attr_reader :subtest
  
  def initialize(elements, path_kind, light, subtest)
    @elements = elements
    @path_kind = path_kind
    @light = light
    @subtest = subtest
  end
  
  def happy_path?
    path_kind == :happy
  end
  
  def processor
    subtest.processor
  end
  
  def relevant_elements
    relevant_element_names.
      select { |name| @elements.element?(name) }.
      map { |name| @elements.element(name) }
  end
  
  def relevant_element_names
    processor.kind.relevant_elements(@light, @subtest.path_kind)
  end
end