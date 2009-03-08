module Workbler
  class Base
    mattr_reader :config
    mattr_reader :workers
    
    @@workers = []
    @@config
    
    def self.load_config
      @@config = Workbler::Config.new("#{RAILS_ROOT}/config/workbler.yml")
    end
    
    def self.discover!
      Dir.glob(Workbler.load_path.map { |p| "#{ p }/**/*.rb" }).each { |worker| require worker }
    end
    
    def self.add_class(klass)
      @@workers << klass
    end
    
  end
end