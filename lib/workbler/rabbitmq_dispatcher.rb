gem 'jerryluk-rabbitmq-jruby-client'
require 'rabbitmq_client'

module Workbler
  class RabbitMQDispatcher
    def initialize
      @client = RabbitMQClient.new
      @queue = @client.queue('workbler')
      @queue.bind(@client.exchange('workbler_exchange'), 'direct')
    end
    
    def run(klass, method, options = {})
      message = { :klass => klass.to_s, :method => method, :options => options }
      @queue.publish(message)
      Workbler.logger.info "Scheduled job: #{options[:uid]}"
    end
  end
end