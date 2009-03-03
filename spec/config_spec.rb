require File.dirname(__FILE__) + '/spec_helper'

describe Workbler::Config do
  before(:each) do
    @config = Workbler::Config.new(File.dirname(__FILE__) + '/data/workble.yml') 
  end
  
  it "should contain basic configuration" do
    @config.should_not be_nil
    @config[:host].should == '127.0.0.1'
    @config[:queue].should_not be_nil
  end
  
end