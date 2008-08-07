require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::TrafficLight do
  before(:each) do
    @traffic_light = CIAT::TrafficLight.new
  end

  it "should set and query green" do
    @traffic_light.green?.should == false
    @traffic_light.green!
    @traffic_light.green?.should == true
  end
  
  it "should set and query yellow" do
    @traffic_light.yellow?.should == false
    @traffic_light.yellow!
    @traffic_light.yellow?.should == true    
  end
  
  it "should set and query red" do
    @traffic_light.red?.should == false
    @traffic_light.red!
    @traffic_light.red?.should == true    
  end
  
  it "should not switch away from yellow" do
    @traffic_light.yellow!
    @traffic_light.yellow?.should == true
    @traffic_light.red!
    @traffic_light.green!
    @traffic_light.yellow?.should == true
    @traffic_light.red?.should == false
    @traffic_light.green?.should == false
  end
end
