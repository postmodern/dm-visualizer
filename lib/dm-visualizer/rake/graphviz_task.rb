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
          common_options = {:bundle => File.file?('Gemfile')}
          common_options.merge!(options)

          graphviz = lambda { |type,format|
            GraphViz.new(common_options.merge(
              :naming => type,
              :file => "doc/#{type}_diagram",
              :format => format
            ))
          }

          @graphviz = {
            :relational => {
              :png => graphviz[:relational, :png],
              :svg => graphviz[:relational, :svg]
            },

            :schema => {
              :png => graphviz[:schema, :png],
              :svg => graphviz[:schema, :svg]
            }
          }

          super
        end

        #
        # Defines the `dm:doc:graphviz` namespace.
        #
        def define
          super do
            namespace :graphviz do
              namespace :relational do
                desc 'Generates a PNG GraphViz relational diagram of the DataMapper Models'
                task :png do
                  @graphviz[:relational][:png].visualize!
                end

                desc 'Generates a SVG GraphViz relational diagram of the DataMapper Models'
                task :svg do
                  @graphviz[:relational][:svg].visualize!
                end
              end

              task :relational => ['relational:png', 'relational:svg']

              namespace :schema do
                desc 'Generates a PNG GraphViz schema diagram of the DataMapper Models'
                task :png do
                  @graphviz[:schema][:png].visualize!
                end

                desc 'Generates a SVG GraphViz schema diagram of the DataMapper Models'
                task :svg do
                  @graphviz[:schema][:svg].visualize!
                end
              end

              task :schema => ['schema:png', 'schema:svg']
            end

            task :graphviz => ['graphviz:relational', 'graphviz:schema']
          end
        end

      end
    end
  end
end
