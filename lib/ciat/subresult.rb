class CIAT::Subresult
  attr_reader :light
  attr_reader :processor
  
  def initialize(elements, light, processor)
    @elements = elements
    @light = light
    @processor = processor
  end
  
  def relevant_elements
    relevant_element_names.
      select { |name| @elements.element?(name) }.
      map { |name| @elements.element(name) }
  end
  
  def relevant_element_names
    @processor.kind.element_name_hash[@light.setting]
  end
end