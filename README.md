# dm-visualizer

* [Source](https://github.com/postmodern/dm-visualizer/)
* [Issues](https://github.com/postmodern/dm-visualizer/issues)
* [Documentation](http://rubydoc.info/gems/dm-visualizer/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

DataMapper Visualizer is both a library and a command-line utility for
visualizing the Models, Properties and Relationships defined in a
DataMapper based Ruby project.

## Features

* Safely loads the models of a project.
* Supports using [Bundler].
* Generates [GraphViz] diagrams for a project:
  * Supports generating Relational and Schema diagrams.
  * Provides PNG and SVG output.
  * Provides Rake tasks for both Ruby libraries and dm-rails apps.
* Supports [DataMapper] >= 1.0.0.

## Examples

Add the `dm:doc:graphviz` rake tasks to a Ruby library:

    require 'dm-visualizer/rake/graphviz_task'
    DataMapper::Visualizer::Rake::GraphVizTask.new(
      :include => ['lib'],
      :require => ['my_library/models']
    )

Add the `dm:doc:graphviz` rake tasks to a [Padrino] app:

    require 'dm-visualizer/rake/padrino/graphviz_task'
    DataMapper::Visualizer::Rake::Padrino::GraphVizTask.new

Add the `dm:doc:graphviz` rake tasks to a [dm-rails] app:

    require 'dm-visualizer/rake/rails/graphviz_task'
    DataMapper::Visualizer::Rake::Rails::GraphVizTask.new

## Requirements

* [ruby-graphviz] ~> 1.0
* [dm-core] ~> 1.0

## Install

    $ gem install dm-visualizer

## License

Copyright (c) 2010-2012 Hal Brodigan

See {file:LICENSE.txt} for license information.

[GraphViz]: http://www.graphviz.org/
[DataMapper]: http://datamapper.org/
[Bundler]: http://bundler.io/
[Padrino]: http://www.padrinorb.com/
[dm-rails]: http://github.com/datamapper/dm-rails

[ruby-graphviz]: http://rubygems.org/gems/ruby-graphviz
[dm-core]: http://github.com/datamapper/dm-core
