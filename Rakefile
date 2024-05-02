task default: [:clean, :build, :install, :test]

task :clean do
  spec = Gem::Specification::load("spriggan.gemspec")
  if File.exist?("Gemfile.lock")
    f = File.open("Gemfile.lock", "r")
    File.delete(f)
  end
  if File.exist?("#{spec.name}-#{spec.version}.gem")
    f = File.open("#{spec.name}-#{spec.version}.gem", "r")
    File.delete(f)
  end
end #task

task :build do
  sh "gem build spriggan.gemspec"
end #task

task :install do
  sh "gem install spriggan"
end #task

task :test do
  ruby "test/function_tests.rb"
end #task
