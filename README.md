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
  * Provides Rake tasks for both Ruby libraries and Rails3 apps.
* Supports both DataMapper 0.10.2 and 0.10.3.

## Synopsis

Visualize a library that uses DataMapper:

    $ dm-visualizer graphviz doc/data_mapper.png -I lib -I ext -r library

Visualize a Rails 3 project that is using dm-rails:

    $ dm-visualizer graphviz doc/data_mapper.png -I lib . -R app/models/*.rb

## Examples

Add the `dm:doc:graphviz` rake task to a Ruby library:

    require 'dm-visualizer/rake/library/graphviz_task'
    DataMapper::Visualizer::Rake::Library::GraphVizTask.new(
      :require => ['my_library/models']
    )

Add the `db:doc:graphviz` rake task to a Rails3 / [dm-rails](http://github.com/datamapper/dm-rails) app:

    require 'dm-visualizer/rake/rails/graphviz_task'
    DataMapper::Visualizer::Rake::Rails::GraphVizTask.new

## Requirements

* [dm-core](http://github.com/datamapper/dm-core) >= 0.10.2

## Install

    $ sudo gem install dm-visualizer

## License

See {file:LICENSE.txt} for license information.

