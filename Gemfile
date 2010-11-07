source 'https://rubygems.org'

gemspec

group(:development) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'rake',		'~> 0.8.7'
  gem 'ore-core',	'~> 0.1.0'
  gem 'ore-tasks',	'~> 0.2.0'
  gem 'rspec',		'~> 2.0.0'
end
