source 'https://rubygems.org'

gem 'ruby-graphviz',	'>= 0.9.10'
gem 'dm-core',		'>= 0.10.2'
gem 'thor',		'~> 0.14.0'

group(:development) do
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.5.0.pre'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.6.0'
end

gem 'rspec',	'~> 1.3.0', :group => [:development, :test]
