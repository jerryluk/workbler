gem 'jerryluk-rabbitmq-jruby-client'
require 'rabbitmq_client'

module Workbler
  class RabbitMQDispatcher
    def initialize
      @persist = Workbler::Base.config[:persist]
      @client = RabbitMQClient.new(:host     => Workbler::Base.config[:host],
                                   :port     => Workbler::Base.config[:port],
                                   :username => Workbler::Base.config[:username],
                                   :password => Workbler::Base.config[:password],
                                   :vhost    => Workbler::Base.config[:vhost])
      @queue = @client.queue(Workbler::Base.config[:queue], Workbler::Base.config[:persist])
      @queue.bind(@client.exchange("#{Workbler::Base.config[:queue]}_#{Time.now.to_i}_#{rand(1<<64)}", 
        Workbler::Base.config[:exchange_type], Workbler::Base.config[:persist]),
        Workbler::Base.config[:routing_key])
    end
    
    def run(klass, method, options = {})
      message = { :klass => klass.to_s, :method => method, :options => options }
      @persist ? @queue.publish(message, RabbitMQClient::MessageProperties::PERSISTENT_TEXT_PLAIN) : @queue.publish(message)
      Workbler.logger.info "Scheduled job: #{options[:uid]}"
    end
  end
end