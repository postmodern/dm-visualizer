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

      # The output file
      attr_accessor :file

      # The output file format (`:svg`)
      attr_accessor :format

      # The colors to use
      attr_reader :colors

      # The labels to use
      attr_reader :labels

      #
      # Creates a new GraphViz object.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :file
      #   The output file path.
      #
      # @option options [Symbol] :format (:svg)
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
      def initialize(options={})
        super(options)

        @format = :svg

        @colors = {
          :one_to_many => 'blue',
          :one_to_one => 'red',
          :inheritence => 'cyan'
        }
        @labels = {
          :one_to_many => '1:m',
          :one_to_one => '1:1'
        }

        if options[:file]
          @file = File.expand_path(options[:file])
        end

        if options[:format]
          @format = options[:format].to_sym
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
      # The full output path.
      #
      # @return [String]
      #   The full output path, including file extension.
      #
      def path
        "#{@file}.#{@format}"
      end

      protected

      #
      # Generates a GraphViz diagram for a project.
      #
      # @param [String] path
      #   The path to save the graph image to.
      #
      def visualize
        graph = ::GraphViz.new(:G, :type => :digraph)

        # Create node for each model
        project.each_model do |model|
          properties = project.each_property(model).map do |property|
            "#{property_name(property)}: #{property_type_name(property)}"
          end

          foreign_keys = project.each_foreign_key(model).map do |key,value|
            "#{foreign_key_name(key)}: #{model_name(value)}"
          end

          columns = (properties + foreign_keys)
          label = "{ #{model_name(model)} | #{columns.join("\n")} }"

          graph.add_node(
            model_name(model),
            :shape => 'record',
            :label => label
          )
        end

        # Connect model nodes together by relationship
        project.each_relationship do |relationship,model|
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

        # Connect model nodes by inheritence
        project.each_model_inheritence do |model,ancestor|
          source_node = graph.get_node(model_name(ancestor))
          target_node = graph.get_node(model_name(model))

          graph.add_edge(
            source_node,
            target_node,
            :color => @colors[:inheritence]
          )
        end

        graph.output(@format => self.path)
      end

    end
  end
end
