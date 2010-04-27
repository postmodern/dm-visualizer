require 'dm-visualizer/rake/rails/task'
require 'dm-visualizer/graphviz'

module DataMapper
  module Visualizer
    module Rake
      module Rails
        class GraphVizTask < Task

          # The default output file for {GraphViz}
          DEFAULT_OUTPUT = 'doc/data_mapper.png'

          # The GraphViz visualizer
          attr_reader :graphviz

          # The output path for GraphViz
          attr_accessor :output

          #
          # Creates a new `db:doc:graphviz` task.
          #
          # @param [Hash] options
          #   Additional options.
          #
          # @option options [String] :output (DEFAULT_OUTPUT)
          #   The file to save the GraphViz diagram to.
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
            @output = (options.delete(:output) || DEFAULT_OUTPUT)
            @graphviz = GraphViz.new(DEFAULT_OPTIONS.merge(options))

            super
          end

          #
          # Defines the `db:doc:graphviz` task.
          #
          def define
            super do
              desc 'Generates a GraphViz diagram of the DataMapper Models'
              task :graphviz => 'db:load_models' do
                @graphviz.visualize!(@output)
              end
            end
          end

        end
      end
    end
  end
end
