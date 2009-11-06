shared_examples_for "Any element namer" do
  describe "element-name hash" do
    [:red, :yellow, :green, :unset].each do |color|
      [:happy, :sad].each do |path|
        it "should compute relevant elements for #{color} light and #{path} path" do
          @namer.relevant_elements(color, path).should be_an_instance_of(Array)
        end
      end
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
