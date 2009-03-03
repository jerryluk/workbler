require 'workbler/workbler'
require 'workbler/base'
require 'workbler/worker'
require 'workbler/listener'
require 'workbler/rabbitmq_dispatcher'
require 'workbler/rabbitmq_invoker'

Workbler::Base.load_config
Workbler::Base.discover!