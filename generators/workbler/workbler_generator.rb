class WorkblerGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory 'config'
      m.file 'config/startup.rb',   File.join('config', 'startup.rb')
      m.file 'config/warble.rb',    File.join('config', 'warble.rb')
      m.file 'config/web.xml',      File.join('config', 'web.xml.erb')
      m.file 'config/workble.rb',   File.join('config', 'workble.rb')
      m.file 'config/workbler.yml', File.join('config', 'workbler.yml')
      m.directory 'script'
      m.file 'script/workbler',     File.join('script', 'workbler')
      m.directory 'classes'
      m.directory 'classes/jruby'
      m.directory 'classes/jruby/ext'
      m.file 'classes/jruby/ext/StartupScriptLauncher.class', 
        File.join('classes', 'jruby', 'ext', 'StartupScriptLauncher.class')
    end
  end
end
