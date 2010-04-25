require 'set'
require 'dm-core'

module DataMapper
  module Visualizer
    #
    # Defines the paths and directories to load for a DataMapper project.
    #
    class Project

      # The directories to include
      attr_reader :include_dirs

      # Specifies which Bundler groups to activate.
      attr_accessor :bundle

      # The paths to require
      attr_reader :require_paths

      # The path glob patterns to require
      attr_reader :require_globs

      #
      # Creates a new project.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Array] :include
      #   The directories to include into the `$LOAD_PATH` global variable.
      #
      # @option options [Boolean, Array] :bundle
      #   Specifies which groups of dependencies to activate using Bundler.
      #
      # @option options [Array] :require
      #   The paths to require.
      #
      # @option options [Array] :require_all
      #   The path globs to require.
      #
      def initialize(options={})
        @include_dirs = Set[]
        @bundle = Set[]
        @require_paths = Set[]
        @require_globs = Set[]

        if options[:include]
          options[:include].each do |dir|
            @include_dirs << File.expand_path(dir)
          end
        end

        if options[:bundle]
          options[:bundle].each do |group|
            @bundle << group.to_sym
          end
        end

        if options[:require]
          @require_paths += options[:require]
        end

        if options[:require_all]
          @require_globs += options[:require_all]
        end
      end

      #
      # Activates dependencies of the project using Bundler.
      #
      # @return [true]
      #
      def bundle!
        unless File.file?('Gemfile')
          STDERR.puts "Gemfile is missing or not a valid file."
        end

        begin
          require 'bundler'
        rescue LoadError => e
          STDERR.puts "Gemfile exists, but bundler is not installed"
          STDERR.puts "Run `gem install bundler` to install bundler."
        end

        begin
          Bundler.setup(*@bundle)
        rescue Bundler::BundleError => e
          STDERR.puts e.message
          STDERR.puts "Run `bundle install` to install missing gems"
        end

        return true
      end

      #
      # Activates the project by adding it's include directories to the
      # `$LOAD_PATH` global variable.
      #
      # @return [true]
      #
      def activate!
        @include_dirs.each do |dir|
          $LOAD_PATH << dir if File.directory?(dir)
        end

        # use Bundler if a Gemfile is present
        bundle! if File.file?('Gemfile')

        return true
      end

      #
      # De-activates the project by removing it's include directories to the
      # `$LOAD_PATH` global variable.
      #
      # @return [true]
      #
      def deactivate!
        $LOAD_PATH.reject! { |dir| @include_dirs.include?(dir) }
        return true
      end

      #
      # Attempts to load all of the projects files.
      #
      # @return [true]
      #
      def load!
        activate!

        @require_paths.each do |path|
          begin
            require path
          rescue LoadError => e
            STDERR.puts "dm-visualizer: unable to load #{path}"
            STDERR.puts "dm-visualizer: #{e.message}"
          end
        end

        @require_globs.each do |glob|
          @include_dirs.each do |dir|
            Dir[File.join(dir,glob)].each do |path|
              relative_path = path[(dir.length + 1)..-1]

              begin
                require relative_path
              rescue LoadError => e
                STDERR.puts "dm-visualizer: unable to load #{relative_path} from #{dir}"
                STDERR.puts "dm-visualizer: #{e.message}"
              end
            end
          end
        end

        deactivate!
        return true
      end

      #
      # Enumerates over each DataMapper Model loaded from the project.
      #
      # @yield [model]
      #   The given block will be passed every model registered with
      #   DataMapper.
      #
      # @yieldparam [DataMapper::Model]
      #   A model loaded from the project.
      #
      def each_model(&block)
        DataMapper::Model.descendants.each(&block)
      end

      #
      # Enumerates over each DataMapper Model loaded from the project,
      # and their direct ancestors.
      #
      # @yield [model, direct_ancestor]
      #   The given block will be passed every model and their immediate
      #   ancestor.
      #
      # @yieldparam [DataMapper::Model] model
      #   The model.
      #
      # @yieldparam [DataMapper::Model] direct_ancestor
      #   The first ancestor of the model.
      #
      def each_model_inheritence
        each_model do |model|
          direct_ancestor = model.ancestors[1]

          if direct_ancestor.class == Class
            yield model, direct_ancestor
          end
        end
      end

      #
      # Enumerates over each DataMapper property from a given model.
      #
      # @param [DataMapper::Model] model
      #   The given model.
      #
      # @yield [property]
      #   The given block will be passed every property from the given
      #   model.
      #
      # @yieldparam [DataMapper::Property] property
      #   The property.
      #
      def each_property(model)
        model.properties.each do |property|
          yield property
        end
      end

      #
      # Enumerates over every foreign-key in a given model.
      #
      # @param [DataMapper::Model] model
      #   The given model.
      #
      # @yield [foreign_key, foreign_model]
      #   The given block will be passed every foreign-key and the model
      #   that the foreign-key will reference.
      #
      # @yieldparam [String] foreign_key
      #   The name of the foreign-key.
      #
      # @yieldparam [DataMapper::Model] foreign_model
      #   The model that the foreign-key references.
      #
      def each_foreign_key(model)
        model.relationships.each_value do |relationship|
          yield relationship.child_key.first.name,
                relationship.child_model
        end
      end

      #
      # Enumerates over each DataMapper relationship between each model.
      #
      # @yield [relationship,model]
      #   The given block will be passed every relationship from every
      #   model registered with DataMapper.
      #
      # @yieldparam [DataMapper::Relationship] relationship
      #   The relationship.
      #
      # @yieldparam [DataMapper::Model] model
      #   The model that the relationship belongs to.
      #
      def each_relationship
        each_model do |model|
          model.relationships.each_value do |relationship|
            yield relationship, model
          end
        end
      end

    end
  end
end
