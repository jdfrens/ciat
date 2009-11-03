shared_examples_for "Any element namer" do
  describe "element-name hash" do
    it "should have an element-name hash" do
      @namer.element_name_hash.should be_an_instance_of(Hash)
    end
  
    it "should have a red list" do
      @namer.element_name_hash[:red].should_not be_nil
    end
  
    it "should have a yellow list" do
      @namer.element_name_hash[:yellow].should_not be_nil
    end
  
    it "should have a green list" do
      @namer.element_name_hash[:green].should_not be_nil
    end
  
    it "should have an unset list" do
      @namer.element_name_hash[:unset].should_not be_nil
    end
  end
  
  it "should have an output name" do
    @namer.output_name.should be_an_instance_of(Symbol)
  end
  
  it "should have an input name" do
    @namer.input_name.should be_an_instance_of(Symbol)
  end
  
  it "should have an error name" do
    @namer.error_name.should be_an_instance_of(Symbol)
  end
  
  it "should have a happy_path?" do
    @namer.happy_path_element.should be_an_instance_of(Symbol)
  end
end
