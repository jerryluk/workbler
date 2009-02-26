Thread.new do |t|
  listener = Workbler::Listener.new
  listener.listen
end