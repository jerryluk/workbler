require File.dirname(__FILE__) + '/spec_helper'

describe Workbler::RabbitMQInvoker do
  
  class TestWorker < Workbler::Worker
    def test
      puts "Hello"
    end
  end
  
  before(:each) do
    @worker = TestWorker.new
    @workers = {'TestWorker' => @worker }
    @queue = mock('rabbitmq_queue', :bind => true, :publish => true)
    @client = mock('rabbitmq_client', :queue => @queue, :exchange => true)
    RabbitMQClient.stub!(:new).and_return(@client)
    @invoker = Workbler::RabbitMQInvoker.new(@workers)
  end
  
  it "should initialize a client and connect to a queue" do
    RabbitMQClient.should_receive(:new).and_return(@client)
    @client.should_receive(:queue).and_return(@queue)
    @client.should_receive(:exchange)
    @queue.should_receive(:bind)
    invoker = Workbler::RabbitMQInvoker.new(@workers)
  end
  
  it "should invoke a method with options when calling dispatch!" do
    @worker.should_receive(:test).with(hash_including(:option1))
    @invoker.dispatch!('TestWorker', 'test', {:option1 => 'abc', :uid => 'abc'})
  end
  
  it "should call dispatch when it receives a message" do
    def @queue.subscribe(&block)
      block.call({:klass => 'Test', :method => :AMethod, :options => {}})
    end
    @invoker.should_receive(:dispatch!).and_return true
    @invoker.listen
  end
  
  it "should able to stop the invoker" do
    @client.should_receive(:disconnect)
    @invoker.stop
  end
  
end