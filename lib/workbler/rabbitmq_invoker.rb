gem 'jerryluk-rabbitmq-jruby-client'
require 'rabbitmq_client'

module Workbler
  class RabbitMQInvoker
    def initialize(workers)
      @workers = workers
      @client = RabbitMQClient.new
      @queue = @client.queue('workbler')
      @queue.bind(@client.exchange('workbler_exchange'), 'direct')
    end
    
    def listen
      loop do
        message = @queue.retrieve
        if message
          klass = message[:klass].camelize
          method = message[:method]
          options = message[:options]
          dispatch!(klass, method, options)
        else
          sleep 1
        end
      end
    end
    
    def dispatch!(klass, method, options = {})
      begin
        Workbler.logger.info "Dispatching job: #{options.delete(:uid)}"
        # Workbler.find(klass, method).send(method, options)
        @workers[klass].send(method, options)
      rescue Exception => e
        Workbler.logger.info "WORKBLER ERROR: runner could not invoke #{ self.class }:#{ method } with #{ options.inspect }. error was: #{ e.inspect }\n #{ e.backtrace.join("\n") }"
      end
    end
  end
end