class CIAT::Subresult
  attr_reader :light
  attr_reader :processor
  
  def initialize(elements, path_kind, light, processor)
    @elements = elements
    @path_kind = path_kind
    @light = light
    @processor = processor
  end
  
  def relevant_elements
    relevant_element_names.
      select { |name| @elements.element?(name) }.
      map { |name| @elements.element(name) }
  end
  
  def relevant_element_names
    # FIXME: work in @path_kind
    @processor.kind.element_name_hash[@light.setting]
  end
end