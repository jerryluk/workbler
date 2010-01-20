# Load Rails Environment
require 'jruby/rack/rails'
JRuby::Rack::RailsServletHelper.instance.load_environment

# Tasks to run before starting up Rails server (e.g. migrations)
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate/", nil)

Thread.new do |t|
  require 'workble'
  Thread.stop
end

# Other Background Tasks
Thread.new do |t|

end