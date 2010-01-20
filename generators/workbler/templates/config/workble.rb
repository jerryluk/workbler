n = Workbler::Base.config[:num_workers]

n.times do 
  listener = Workbler::Listener.new
  listener.listen
end

puts "#{n} Listeners are online."