begin
  $: << 'lib'; %w( rubygems rake/testtask rake/rdoctask rake/gempackagetask ).each { |dep| require dep }
rescue LoadError => e
  puts "LoadError: you might want to try running the setup task first."
  raise e
end

runtime_deps = { :facets => '>= 1.0' }

gem = Gem::Specification.new do |gem|
  gem.name = "hive"
  # gem.rubyforge_project = "hive"
  gem.summary = "Open-source Ruby framework for background processing."
  gem.version = File.read('doc/VERSION')
  gem.homepage = 'http://github.com/dyoder/hive'
  gem.author = 'Dan Yoder'
  gem.email = 'dan@zeraweb.com'
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8.7'
  runtime_deps.each { | name, version | gem.add_runtime_dependency( name.to_s, version ) }
  gem.files = FileList[ 'lib/**/*.rb' ]
  gem.has_rdoc = true
  gem.bindir = 'bin'
  gem.executables = []
end

desc "Create the gem"
task( :package => [ :clean, :rdoc, :gemspec ] ) { Gem::Builder.new( gem ).build }

desc "Clean build artifacts"
task( :clean ) { FileUtils.rm_rf Dir['*.gem', '*.gemspec'] }

desc "Create .gemspec file (useful for github)"
task :gemspec do
  filename = "#{gem.name}.gemspec"
  File.open(filename, "w") do |f|
    f.puts gem.to_ruby
  end
end

desc "Publish to RubyForge"
task( :publish => [ :package, :rdoc_publish ] ) do
  `rubyforge login`
  `rubyforge add_release #{gem.name} #{gem.name} #{gem.version} #{gem.name}-#{gem.version}.gem`
end

task( :rdoc_publish => :rdoc ) do
  path = "/var/www/gforge-projects/#{gem.name}/"
  `rsync -a --delete ./doc/rdoc/ dyoder67@rubyforge.org:#{path}`
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'doc/README'
  rdoc.rdoc_files.add [ 'lib/**/*.rb', 'doc/*' ]
end

# TODO: run tests