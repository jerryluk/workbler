# Load Rails Environment
require 'jruby/rack/rails'
require 'jruby/rack/boot/rails'
JRuby::Rack.booter.boot!
JRuby::Rack.booter.load_environment

require 'workble'
require 'quantum_checker'

# Tasks to run before starting up Rails server (e.g. migrations)
# ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate/", nil)
class BackgroundTask
  @@workble = nil
  
  def self.start
    Thread.new do |t|
      @@workble = Workble.new
      Thread.stop
    end
    
    # Background Tasks
    Thread.new do |t|
      checker = QuantumChecker.new
      checker.run
    end
  end
  
  def self.stop
    Workbler.destroy
    @@workble.stop if @@workble
  end
end