require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::TrafficLight do
  it "should respond to unset?" do
    CIAT::TrafficLight::UNSET.unset?.should == true
    CIAT::TrafficLight::RED.unset?.should == false
    CIAT::TrafficLight::YELLOW.unset?.should == false
    CIAT::TrafficLight::GREEN.unset?.should == false
  end
  
  it "should respond to red?" do
    CIAT::TrafficLight::UNSET.red?.should == false
    CIAT::TrafficLight::RED.red?.should == true
    CIAT::TrafficLight::YELLOW.red?.should == false
    CIAT::TrafficLight::GREEN.red?.should == false
  end
  
  it "should respond to yellow?" do
    CIAT::TrafficLight::UNSET.yellow?.should == false
    CIAT::TrafficLight::RED.yellow?.should == false
    CIAT::TrafficLight::YELLOW.yellow?.should == true
    CIAT::TrafficLight::GREEN.yellow?.should == false
  end

  it "should respond to green?" do
    CIAT::TrafficLight::UNSET.green?.should == false
    CIAT::TrafficLight::RED.green?.should == false
    CIAT::TrafficLight::YELLOW.green?.should == false
    CIAT::TrafficLight::GREEN.green?.should == true
  end
end
