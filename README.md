# dm-visualizer

* [Source](http://github.com/postmodern/dm-visualizer/)
* [Issues](http://github.com/postmodern/dm-visualizer/issues)
* [Documentation](http://rubydoc.info/gems/dm-visualizer/frames)
* [Email](postmodern.mod3 at gmail.com)

## Description

DataMapper Visualizer is both a library and a command-line utility for
visualizing the Models, Properties and Relationships defined in a
DataMapper based Ruby project.

## Features

* Safely loads the models of a project.
* Supports using [Gem Bundler](http://gembundler.com/).
* Generates GraphViz diagrams for a project:
  * Supports generating Relational and Schema diagrams.
  * Provides PNG and SVG output.
  * Provides Rake tasks for both Ruby libraries and dm-rails apps.
* Supports DataMapper >= 1.0.0.

## Examples

Add the `dm:doc:graphviz` rake tasks to a Ruby library:

    require 'dm-visualizer/rake/graphviz_task'
    DataMapper::Visualizer::Rake::GraphVizTask.new(
      :include => ['lib'],
      :require => ['my_library/models']
    )

Add the `db:doc:graphviz` rake tasks to a [dm-rails](http://github.com/datamapper/dm-rails) app:

    require 'dm-visualizer/rake/rails/graphviz_task'
    DataMapper::Visualizer::Rake::Rails::GraphVizTask.new

## Requirements

* [ruby-graphviz](http://rubygems.org/gems/ruby-graphviz) >= 0.9.10
* [dm-core](http://github.com/datamapper/dm-core) ~> 1.0

## Install

    $ sudo gem install dm-visualizer

## License

Copyright (c) 2010-2011 Hal Brodigan

See {file:LICENSE.txt} for license information.
