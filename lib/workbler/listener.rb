module Workbler
  class Listener
    
    def initialize
      @workers = {}
      Workbler::Base.workers.each do |klass|
        @workers[klass.to_s] = klass.new
      end
      @workers.freeze
    end
    
    def listen
      @listener ||= Workbler::RabbitMQInvoker.new(@workers)
      @listener.listen
    end
    
    def destroy
      @listener.stop
    end
  end
end