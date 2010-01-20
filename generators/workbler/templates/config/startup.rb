# Load Rails Environment
require 'jruby/rack/rails'
JRuby::Rack::RailsServletHelper.instance.load_environment

# Tasks to run before starting up Rails server (e.g. migrations)
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate/", nil)

# Background Tasks
Thread.new do |t|

end

require 'workble'
Thread.stop