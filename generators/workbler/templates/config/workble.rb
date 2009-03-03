n = Workbler::Base.config[:num_workers]

n.times do 
  Thread.new do |t|
    listener = Workbler::Listener.new
    listener.listen
  end
end

puts "#{n} Listeners are online."