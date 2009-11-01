require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + "/shared_examples_for_element_names"

require 'ciat/processors/compilation_interpreter'

describe CIAT::Processors::CompilationInterpreter do
  it_should_behave_like "Any element namer"
  
  before(:each) do
    @namer = CIAT::Processors::CompilationInterpreter.new
  end
end