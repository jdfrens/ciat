require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + "/shared_examples_for_element_names"

require 'ciat/processors/compiler'

describe CIAT::Processors::Compiler do
  it_should_behave_like "Any element namer"
  
  before(:each) do
    @namer = CIAT::Processors::Compiler.new
  end
end