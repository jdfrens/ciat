class CIAT::Subresult
  attr_reader :light
  attr_reader :subtest
  
  def initialize(elements, path_kind, light, subtest)
    @elements = elements
    @path_kind = path_kind
    @light = light
    @subtest = subtest
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
    # FIXME: work in @path_kind
    processor.kind.element_name_hash[@light.setting]
  end
end