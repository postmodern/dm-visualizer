require 'dm-visualizer/rake/task'
require 'dm-visualizer/graphviz'

require 'set'

module DataMapper
  module Visualizer
    module Rake
      class GraphVizTask < Task

        # The types of GraphViz diagrams.
        DIAGRAMS = Set[:relational, :schema]

        # The image formats for GraphViz diagrams.
        FORMATS = Set[:png, :svg]

        # The types of diagrams to generate.
        attr_reader :diagrams

        # The formats of the diagrams to generate.
        attr_reader :formats

        #
        # Creates a new `dm:doc:graphviz` task.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Boolean] :relational
        #   Specifies whether to generate a relational diagram.
        #
        # @option options [Boolean] :schema
        #   Specifies whether to generate a schema diagram.
        #
        # @option options [Boolean] :png
        #   Specifies whether to generate a PNG image.
        #
        # @option options [Boolean] :svg
        #   Specifies whether to generate a SVG image.
        #
        # @yield [task]
        #   The given block will be passed the newly created task.
        #
        # @yieldparam [GraphVizTask] task
        #   The new GraphViz task.
        #
        # @see GraphViz.new
        #
        def initialize(options={},&block)
          extract_options = lambda { |keys|
            if keys.any? { |key| options[key] }
              keys.select { |key| options.delete(key) }
            else
              keys
            end
          }

          @diagrams = extract_options[DIAGRAMS]
          @formats = extract_options[FORMATS]

          super(options,&block)
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
              @diagrams.each do |type|
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

            task(:graphviz => @diagrams.map { |type| "graphviz:#{type}" })
          end
        end

      end
    end
  end
end
