# dm-visualizer

* [github.com/postmodern/dm-visualizer](http://github.com/postmodern/dm-visualizer/)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

DataMapper Visualizer is both a library and a command-line utility for
visualizing the Models, Properties and Relationships defined in a
DataMapper based Ruby project.

## Features

* Safely loads the models of a project.
* Generates a GraphViz diagram for a project.
* Supports both DataMapper 0.10.2 and 0.10.3.

## Synopsis

Visualize a library that uses DataMapper:

    $ dm-visualizer graphviz doc/schema.png -I lib -I ext -r library

Visualize a Rails 3 project that is using dm-rails:

    $ dm-visualizer graphviz doc/schema.png -I lib -r app/models/*.rb

## Examples

As a rake task in a Ruby library:

    require 'dm-visualizer/graphviz'

    namespace :doc do
      task :db do
        DataMapper::Visualizer::GraphViz.new(
          :include => ['lib'],
          :require => ['my_library/models']
        ).visualize('doc/db.png')
      end
    end

As a rake task in a Rails3 / [dm-rails](http://github.com/datamapper/dm-rails) app:

    require 'dm-visualizer/graphviz'

    namespace :doc do
      task :db => 'db:load_models' do
        DataMapper::Visualizer::GraphViz.new().visualize('doc/db.png')
      end
    end

## Requirements

* [dm-core](http://github.com/datamapper/dm-core) >= 0.10.2

## Install

    $ sudo gem install dm-visualizer

## License

See {file:LICENSE.txt} for license information.

