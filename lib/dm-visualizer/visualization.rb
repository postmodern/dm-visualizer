require 'dm-visualizer/project'

require 'dm-core'

module DataMapper
  module Visualizer
    #
    # The base class for all visualizations.
    #
    class Visualization

      # The inflector to use
      Inflector = if Object.const_defined?('ActiveSupport')
                    ActiveSupport::Inflector
                  else
                    Extlib::Inflection
                  end

      # The project that will be visualized
      attr_reader :project

      # Mapping of DataMapper repository names and their actual names.
      attr_reader :repository_names

      # Specifies which naming style to use (`:ruby` or `:sql`).
      attr_accessor :style

      # Specifies whether to demodulize class names.
      attr_accessor :full_names

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
      # @option options [Symbol] :style
      #   The naming style to use. May be either `:ruby` or `:sql`.
      #
      # @option options [Boolean] :full_names
      #   Specifies whether to demodulize class names.
      #
      def initialize(options={})
        @project = Project.new(options)

        @repository_names = {}
        @style = :ruby
        @full_names = false

        if options[:repository_names]
          options[:repository_names].each do |name,db_name|
            @repository_names[name.to_sym] = db_name.to_s
          end
        end

        if options[:repository_name]
          @database_names[:default] = options[:repository_name].to_s
        end

        if options[:style]
          @style = options[:style].to_sym
        end

        if options.has_key?(:full_names)
          @full_names  = options[:full_names]
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

        name = Inflector.demodulize(name) unless @full_names

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
        property.name.to_s
      end

      #
      # Returns the name the given foreign key.
      #
      # @param [Symbol] key
      #   The foreign key.
      #
      # @return [String]
      #   The foreign key name.
      #
      def foreign_key_name(key)
        key = key.to_s

        key.gsub(/_id$/,'') unless @style == :sql
        return key
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
        @repository_names[model.default_repository_name]
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
        if @style == :sql
          name = model_repository_name(model)
          storage_name = model.storage_names[:default]
          storage_name ||= NamingConventions::Resource::UnderscoredAndPluralized.call(model.name)

          if name
            "#{name}.#{storage_name}"
          else
            storage_name
          end
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
