require "bundler/gem_tasks"
require 'rake/testtask'

task default: [:build, :install, :test, :clean]

task :build do
  sh "gem build spriggan.gemspec"
end #task

task :install do
  sh "gem install spriggan"
end #task

task :test do
  ruby "test/function_tests.rb"
end #task

task :clean do
  spec = Gem::Specification::load("spriggan.gemspec")
  if File.exist?("Gemfile.lock")
    f = File.open("Gemfile.lock", "r")
    File.delete(f)
  end #if
  if File.exist?("#{spec.name}-#{spec.version}.gem")
    f = File.open("#{spec.name}-#{spec.version}.gem", "r")
    File.delete(f)
  end #if
end #task
