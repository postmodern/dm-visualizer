require 'dm-visualizer/project'

require 'dm-core'

module DataMapper
  module Visualizer
    #
    # The base class for all visualizations.
    #
    class Visualization

      # The project that will be visualized
      attr_reader :project

      # Mapping of DataMapper repository names and their actual names.
      attr_reader :repository_names

      # Specifies which naming convention to use (`:ruby` or `:sql`).
      attr_accessor :naming_convention

      # Specifies whether to demodulize class names.
      attr_accessor :demodulize

      #
      # Initializes a new visualization.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Hash] :repository_names
      #   The actual names of the DataMapper repositories.
      #
      # @option options [String] :repository_name
      #   The actual name to use for the `:default` DataMappe repository.
      #
      # @option options [Symbol] :naming_convention
      #   The naming convention to use. May be either `:ruby` or `:sql`.
      #
      # @option options [Boolean] :demodulize
      #   Specifies whether to demodulize class names.
      #
      def initialize(options={})
        @project = Project.new(options)

        @repository_names = {}
        @naming_convention = :ruby
        @demodulize = true

        if options[:repository_names]
          options[:repository_names].each do |name,db_name|
            @repository_names[name.to_sym] = db_name.to_s
          end
        end

        if options[:repository_name]
          @database_names[:default] = options[:repository_name].to_s
        end

        if options[:naming_convention]
          @naming_convention = options[:naming_convention].to_sym
        end

        if options.has_key?(:demodulize)
          @demodulize = options[:demodulize]
        end

        @project.load!
      end

      #
      # Returns the class name of a given object.
      #
      # @param [Class, Object] obj
      #   The object or class.
      #
      # @return [String]
      #   The class name of the object or class.
      #
      def class_name(obj)
        name = if (obj.class == Class || obj.class == Module)
                 obj.name
               else
                 obj.class.name
               end

        name = name.demodulize if @demodulize

        return name
      end

      #
      # Returns the name of a given property.
      #
      # @param [DataMapper::Property] property
      #   The property.
      #
      # @return [String]
      #   The property name.
      #
      def property_name(property)
        property.name
      end

      #
      # Returns the type name of a property.
      #
      # @param [DataMapper::Property] property
      #   The property.
      #
      # @return [String]
      #   The property type name.
      #
      def property_type_name(property)
        class_name(property.type)
      end

      #
      # Returns the repository name of a model.
      #
      # @param [DataMapper::Model] model
      #   The model.
      #
      # @return [String]
      #   The repository name.
      #
      def model_repository_name(model)
        name = @repository_names[model.default_repository_name]
        name ||= model.default_repository_name.to_s

        return name
      end

      #
      # Returns the name of a model.
      #
      # @param [DataMapper::Model] model
      #   The model.
      #
      # @return [String]
      #   The name of the model.
      #
      def model_name(model)
        if @naming_convention == :sql
          "#{model_repository_name(model)}.#{model.storage_name}"
        else
          class_name(model)
        end
      end

      #
      # Default method which visualizes the DataMapper models, properties
      # and relationships.
      #
      # @param [Project] project
      #   The project to visualize.
      #
      def visualize
      end

    end
  end
end
