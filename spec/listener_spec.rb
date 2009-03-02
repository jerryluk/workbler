require File.dirname(__FILE__) + '/spec_helper'

describe Workbler::Listener do
  class TestWorker < Workbler::Worker
    def test
    end
  end
  
  before(:each) do
    @workers = [ TestWorker ]
    @rabbitmq_invoker = mock('rabbitmq_invoker', :listen => true)
    Workbler::Base.stub!(:workers).and_return(@workers)
    Workbler::RabbitMQInvoker.stub!(:new).and_return(@rabbitmq_invoker)
    @listener = Workbler::Listener.new
  end
  
  it "should have a freezed @workers hash with initialized worker instances" do
    module Workbler
      class Listener
        attr_reader :workers
      end
    end
    
    @listener.workers.frozen?.should == true
    @listener.workers['TestWorker'].should be_instance_of(TestWorker)
  end
  
  it "should invoke the listen method on the RabbitMQ Listener" do
    Workbler::RabbitMQInvoker.should_receive(:new).and_return(@rabbitmq_invoker)
    @rabbitmq_invoker.should_receive(:listen).and_return(true)
    @listener.listen
  end
  
end