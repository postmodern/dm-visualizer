require 'dm-visualizer/rake/task'
require 'dm-visualizer/graphviz'

module DataMapper
  module Visualizer
    module Rake
      class GraphVizTask < Task

        # The types of GraphViz diagrams
        TYPES = Set[:relational, :schema]

        # The formats of GraphViz diagrams
        FORMATS = Set[:png, :svg]

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
          extract_options = lambda { |keys|
            if keys.any? { |key| options[key] }
              keys.select { |key| options.delete(key) }
            else
              keys
            end
          }

          @types = extract_options[TYPES]
          @formats = extract_options[FORMATS]

          @options = options.merge(
            :bundle => File.file?('Gemfile')
          )

          super
        end

        #
        # Defines the `dm:doc:graphviz` namespace.
        #
        def define
          graphviz = lambda { |type,format|
            GraphViz.new(@options.merge(
              :naming => type,
              :file => "doc/#{type}_diagram",
              :format => format
            ))
          }

          super do
            namespace(:graphviz) do
              @types.each do |type|
                namespace(type) do
                  @formats.each do |format|
                    desc "Generates a #{format.to_s.upcase} GraphViz #{type} diagram of the DataMapper Models"
                    task(format) do
                      graphviz[type, format].visualize!
                    end
                  end
                end

                task(type => @formats.map { |format| "#{type}:#{format}" })
              end
            end

            task(:graphviz => @types.map { |type| "graphviz:#{type}" })
          end
        end

      end
    end
  end
end
