### 0.2.2 / To be released

* Update ruby-graphviz to 1.0.5
* Make compatible with newer versions of Bundler

### 0.2.1 / 2011-02-12

* Added {DataMapper::Visualizer::Project#each_relationship_for}.
* Fixed a bug in {DataMapper::Visualizer::Project#each_relationship},
  effecting dm-core 1.0.x projects.

### 0.2.0 / 2011-02-09

* Require dm-core >= 1.0.0.
* {DataMapper::Visualizer::Rake::GraphVizTask} now defines tasks for
  generating Relational and Schema diagrams, with PNG and SVG output.
* Fixed a bug in {DataMapper::Visualizer::Rake::Rails::Tasks} which
  prevented dm-visualizer from working in newer dm-rails applications.
* Filter-out foreign-key columns in
  {DataMapper::Visualizer::Project#each_property}.
* Tested against dm-core 1.0.2 and 1.1.0.

### 0.1.0 / 2010-05-27

* Initial release:
  * Safely loads the models of a project.
  * Supports using [Gem Bundler](http://gembundler.com/).
  * Generates GraphViz diagrams for a project.
    * Provides Rake tasks for both Ruby libraries and Rails3 apps.
  * Supports both DataMapper 0.10.2 and 1.0.0.

