require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = 'dm-visualizer'
  gem.license = 'MIT'
  gem.summary = %Q{Visualizes the Models, Properties and Relationships defined in a DataMapper based Ruby project.}
  gem.description = %Q{DataMapper Visualizer is both a library and a command-line utility for visualizing the Models, Properties and Relationships defined in a DataMapper based Ruby project.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/postmodern/dm-visualizer'
  gem.authors = ['Postmodern']
  gem.has_rdoc = 'yard'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
