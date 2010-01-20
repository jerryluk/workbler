require File.dirname(__FILE__) + '/spec_helper'

describe Workbler::RabbitMQDispatcher do
  before(:each) do
    @queue = mock('rabbitmq_queue', :bind => true, :publish => true)
    @client = mock('rabbitmq_client', :queue => @queue, :exchange => true)
    RabbitMQClient.stub!(:new).and_return(@client)
    @dispatcher = Workbler::RabbitMQDispatcher.new
  end
  
  it "should initialize a client and connect to a queue" do
    RabbitMQClient.should_receive(:new).and_return(@client)
    @client.should_receive(:queue).and_return(@queue)
    @client.should_receive(:exchange)
    @queue.should_receive(:bind)
    dispatcher = Workbler::RabbitMQDispatcher.new
  end
  
  it "should publish a message" do
    @queue.should_receive(:publish).with(hash_including({:klass => 'klass', :method => :method, :options => {:option => 1}}))
    @dispatcher.run(:klass, :method, {:option => 1})
  end
  
  it "should able to stop the dispatcher" do
    @client.should_receive(:disconnect)
    @dispatcher.stop
  end
  
end