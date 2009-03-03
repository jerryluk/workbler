module Workbler
  class Config
    def initialize(filename)
      # @config =  deep_symbolize_keys(YAML.load(ERB.new(IO.read(filename)).result)0
      # Default values
      config = nil
      begin
        config = deep_symbolize_keys(YAML.load(IO.read(filename)))
      rescue Exception => e
        puts "Cannot load Workbler Config file!"
      end
      @config = config ? config[:defaults].merge(config[RAILS_ENV.to_sym]) : {}
      @config.freeze
    end
    
    def [](k)
      @config[k]
    end
    
    protected
    def deep_symbolize_keys(hash)
      hash.inject({}) { |result, (key, value)|
        value = deep_symbolize_keys(value) if value.is_a? Hash
        result[(key.to_sym rescue key) || key] = value
        result
      }
    end
  end
end