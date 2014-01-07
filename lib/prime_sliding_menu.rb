require 'motion-cocoapods'
require 'motion-prime'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Require.all(Dir.glob(File.expand_path('../prime_sliding_menu/**/*.rb', __FILE__)))

Motion::Project::App.setup do |app|
  app.pods do
    pod 'ECSlidingViewController', "2.0.0-beta2"
  end
end