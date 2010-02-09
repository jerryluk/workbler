require File.dirname(__FILE__) + '/spec_helper'

describe Workbler do
  
  class ThisIsAClass < Workbler::Worker
    def test
    end
  end
  
  before(:each) do
    @rabbitmq_dispatcher = mock('rabbitmq_dispatcher', :run => true)
    Workbler::RabbitMQDispatcher.stub!(:new).and_return(@rabbitmq_dispatcher)
  end
  
  it "should return the class if the class exists" do
    Workbler.find("this_is_a_class").should_not be_nil
  end
  
  it "should raise an exception if the class does not exist" do
    lambda { Workbler.find("this_is_not_a_class") }.should raise_error(Workbler::WorkerNotFoundError)
  end
  
  it "should return the class if the class and the method exists" do
    Workbler.find("this_is_a_class", :test).should_not be_nil
  end
  
  it "should raise an exception if the method does not exist" do
    lambda { Workbler.find("this_is_a_class", :method_does_not_exist) }.should raise_error(Workbler::WorkerNotFoundError)
  end
  
  it "should call the run method in dispatcher with an uid in options" do
    @rabbitmq_dispatcher.should_receive(:run).with("this_is_a_class", :test, hash_including(:uid)).and_return(@rabbitmq_dispatcher)
    Workbler.run("this_is_a_class", :test)
  end
  
  it "should be able to discard all the previous jobs" do
    mock_queue = mock("Queue")
    mock_client = mock("RabbitMQClient", :queue => mock_queue)
    RabbitMQClient.should_receive(:new).and_return(mock_client)
    mock_queue.should_receive(:purge).and_return(true)
    Workbler.discard_jobs
  end
end