require 'dm-visualizer/rake/task'
require 'dm-visualizer/graphviz'

module DataMapper
  module Visualizer
    module Rake
      class GraphVizTask < Task

        # The relational diagram GraphViz visualizer
        attr_reader :relational

        # The schema diagram GraphViz visualizer
        attr_reader :schema

        #
        # Creates a new `dm:doc:graphviz` task.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @yield [task]
        #   The given block will be passed the newly created task.
        #
        # @yieldparam [GraphVizTask] task
        #   The new GraphViz task.
        #
        # @see GraphViz.new
        #
        def initialize(options={})
          @relational = GraphViz.new(options.merge(
            :naming => :relational,
            :file => 'doc/relational_diagram'
          ))

          @schema = GraphViz.new(options.merge(
            :naming => :schema,
            :file => 'doc/schema_diagram'
          ))

          super
        end

        #
        # Defines the `dm:doc:graphviz` task.
        #
        def define
          super do
            namespace :graphviz do
              desc 'Generates a GraphViz relational diagram of the DataMapper Models'
              task :relational do
                @relational.visualize!
              end

              desc 'Generates a GraphViz schema diagram of the DataMapper Models'
              task :schema do
                @schema.visualize!
              end
            end

            task :graphviz => ['graphviz:relational', 'graphviz:schema']
          end
        end

      end
    end
  end
end
