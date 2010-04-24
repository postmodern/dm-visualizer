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

## Synopsis

* Visualize a library that uses DataMapper:

    $ dm-visualizer graphviz doc/schema.png -I lib -I ext -r library

* Visualize a Rails 3 project that is using dm-rails:

    $ dm-visualizer graphviz doc/schema.png -I lib -r app/models/*.rb

## Examples

## Install

    $ sudo gem install dm-visualizer

## License

See {file:LICENSE.txt} for license information.

