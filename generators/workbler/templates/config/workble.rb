class Workble
  attr_reader :listeners
  
  def initialize
    n = Workbler::Base.config[:num_workers]

    @listeners = []

    n.times do 
      listener = Workbler::Listener.new
      listeners << listener
      listener.listen
    end

    puts "#{listeners.size} Listeners are online."
  end
  
  def stop
    @listeners.each { |l| l.destroy }
    
    puts "#{listeners.size} Listeners are offline."
    @listeners = nil
  end
end