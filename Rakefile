require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/iloxx_shipping/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end

task :default => :spec
task :test => :spec