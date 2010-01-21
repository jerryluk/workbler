gem 'rabbitmq-jruby-client'
require 'rabbitmq_client'

module Workbler
  class RabbitMQInvoker
    def initialize(workers)
      @mutex = Mutex.new
      @workers = workers
      @client = RabbitMQClient.new(:host     => Workbler::Base.config[:host],
                                   :port     => Workbler::Base.config[:port],
                                   :username => Workbler::Base.config[:username],
                                   :password => Workbler::Base.config[:password],
                                   :vhost    => Workbler::Base.config[:vhost])
      @queue = @client.queue(Workbler::Base.config[:queue], Workbler::Base.config[:persist])
      exchange_name = "#{Workbler::Base.config[:queue]}_#{Time.now.to_i}_#{rand(1<<64)}_exchange"
      routing_key = "#{Workbler::Base.config[:queue]}_#{Time.now.to_i}_#{rand(1<<64)}_route"
      @queue.bind(@client.exchange(exchange_name, 
        Workbler::Base.config[:exchange_type], 
        Workbler::Base.config[:persist]),
        routing_key)
    end
    
    def listen
      @queue.subscribe do |message|
        @mutex.synchronize do
          klass = message[:klass].camelize
          method = message[:method]
          options = message[:options]
          dispatch!(klass, method, options)
        end
      end
    end
    
    def stop
      @mutex.synchronize do
        @client.disconnect
      end
    end
    
    def dispatch!(klass, method, options = {})
      begin
        uid = options.delete(:uid)
        Workbler.logger.info "Dispatching job: #{uid}"
        Workbler.find(klass, method)
        @workers[klass].send(method, options)
      rescue Exception => e
        Workbler.exception_notify(e, {:type => "dispatch", :uid => uid, :klass => klass.to_s, :method => method.to_s, :options => options})
      end
    end
  end
end