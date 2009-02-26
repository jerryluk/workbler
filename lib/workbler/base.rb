module Workbler
  class Base
    @@workers = []
    
    def self.discover!
      Dir.glob(Workbler.load_path.map { |p| "#{ p }/**/*.rb" }).each { |worker| require worker }
    end
    
    def self.add_class(klass)
      @@workers << klass
    end
    
    def self.workers
      # Make defensive copy if necessary
      @@workers_copy ||= @@workers.clone
    end
    
  end
end