require 'dm-visualizer/visualization'

begin
  require 'graphviz'
rescue Gem::LoadError => e
  raise(e)
rescue ::LoadError
  STDERR.puts "GraphViz not available. Install it with: gem install ruby-graphviz"
end

module DataMapper
  module Visualizer
    #
    # Visualizes projects by generating a
    # [GraphViz](http://www.graphviz.org/) diagram.
    #
    class GraphViz < Visualization

      # The output path
      attr_accessor :path

      # The output file format (`:png`)
      attr_accessor :output_format

      # The colors to use
      attr_reader :colors

      # The labels to use
      attr_reader :labels

      #
      # Creates a new GraphViz object.
      #
      # @param [String] path
      #   The path to save the graph to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol] :output_format (:png)
      #   The format of the generated graph.
      #
      # @option options [Hash] :colors
      #   The colors to use for `:one_to_many` and `:one_to_one`
      #   relationship edges.
      #
      # @option options [Hash] :labels
      #   The labels to use for `:one_to_many` and `:one_to_one`
      #   relationship edges.
      #
      def initialize(path,options={})
        super(options)

        @path = path
        @output_format = :png

        @colors = {:one_to_many => 'blue', :one_to_one => 'red'}
        @labels = {:one_to_many => '1:m', :one_to_one => '1:1'}

        if options[:output_format]
          @output_format = options[:output_format].to_sym
        end

        if options[:colors]
          options[:colors].each do |name,value|
            @colors[name.to_sym] = value.to_s
          end
        end

        if options[:labels]
          options[:labels].each do |name,value|
            @labels[name.to_sym] = value.to_s
          end
        end
      end

      #
      # Generates a GraphViz diagram for a project.
      #
      # @param [Project] project
      #   The project to visualize.
      #
      def visualize
        graph = ::GraphViz.new(:G, :type => :digraph)

        # Create node for each model
        project.each_model do |model|
          properties = model.properties.map do |property|
            "#{property_name(property)}: #{property_type_name(property)}"
          end

          label = "{ #{model_name(model)} | #{properties.join("\n")} }"

          graph.add_node(
            model_name(model),
            :shape => 'record',
            :label => label
          )
        end

        # Connect nodes together
        project.each_relationship do |relationship,model|
          next if relationship.respond_to?(:through)

          source_node = graph.get_node(model_name(model))
          target_node = graph.get_node(model_name(relationship.target_model))

          case relationship
          when DataMapper::Associations::OneToMany::Relationship
            graph.add_edge(
              source_node,
              target_node,
              :color => @colors[:one_to_many],
              :label => " #{@labels[:one_to_many]}"
            )
          when DataMapper::Associations::OneToOne::Relationship
            graph.add_edge(
              source_node,
              target_node,
              :color => @colors[:one_to_one],
              :label => " #{@labels[:one_to_one]}"
            )
          end
        end

        graph.output(@output_format => @path)
      end

    end
  end
end
