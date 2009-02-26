module Workbler
  class Worker
    cattr_accessor :logger
    @@logger ||= RAILS_DEFAULT_LOGGER
    
    def self.inherited(subclass)
      Workbler::Base.add_class subclass
    end
  end
end