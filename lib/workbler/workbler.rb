require 'digest/md5'

# Workbler
module Workbler
  class WorkblerError < StandardError; end
  class WorkerNotFoundError < WorkblerError; end
  
  mattr_accessor :load_path
  mattr_accessor :logger
  
  @@logger ||= RAILS_DEFAULT_LOGGER
  @@dispatcher = nil
  @@mutex = Mutex.new
  # @@load_path = [ File.expand_path(File.join(File.dirname(__FILE__), '../../../app/workers')) ]
  @@load_path = "#{RAILS_ROOT}/app/workers"
  
  def self.run(klass, method, options = {})
    uid = Digest::MD5.hexdigest("#{klass}_#{method}_#{Time.now.to_i}_#{rand(1<<64)}")
    self.find(klass, method)
    options[:uid] = uid if options.kind_of?(Hash) && !options[:uid]
    @@mutex.synchronize do
      @@dispatcher ||= Workbler::RabbitMQDispatcher.new
      begin
        @@dispatcher.run(klass, method, options)
      rescue Exception => e
        Workbler.logger.info "Exception in Workbler Dispatcher: + #{e.backtrace}"
      end
    end
    uid
  end
  
  def self.destroy
    @@mutex.synchronize do
      @@dispatcher.stop if @@dispatcher
    end
  end
  
  # Copied from Workling
  # gets the worker instance, given a class. the optional method argument will cause an 
  # exception to be raised if the worker instance does not respoind to said method. 
  #
  def self.find(clazz, method = nil)
    begin
      inst = clazz.to_s.camelize.constantize.new 
    rescue NameError
      raise_not_found(clazz, method)
    end
    raise_not_found(clazz, method) if method && !inst.respond_to?(method)
    inst
  end
  
  # Copy from Workling
  private
    def self.raise_not_found(clazz, method)
      raise Workbler::WorkerNotFoundError.new("could not find #{ clazz }:#{ method } worker. ") 
    end
  
end