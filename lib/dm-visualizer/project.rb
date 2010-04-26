require 'set'
require 'dm-core'

require 'enumerator'

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
          log "Gemfile is missing or not a valid file."
        end

        begin
          require 'bundler'
        rescue LoadError => e
          log "Gemfile exists, but bundler is not installed"
          log "Run `gem install bundler` to install bundler."
        end

        begin
          Bundler.setup(*@bundle)
        rescue Bundler::BundleError => e
          log e.message
          log "Run `bundle install` to install missing gems"
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
            log "dm-visualizer: unable to load #{path}"
            log "dm-visualizer: #{e.message}"
          end
        end

        @require_globs.each do |glob|
          @include_dirs.each do |dir|
            Dir[File.join(dir,glob)].each do |path|
              relative_path = path[(dir.length + 1)..-1]

              begin
                require relative_path
              rescue LoadError => e
                log "dm-visualizer: unable to load #{relative_path} from #{dir}"
                log "dm-visualizer: #{e.message}"
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
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
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
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      def each_model_inheritence
        unless block_given?
          return Enumerator.new(self,:each_model_inheritence)
        end

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
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      def each_property(model)
        unless block_given?
          return Enumerator.new(self,:each_property,model)
        end

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
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      def each_foreign_key(model)
        unless block_given?
          return Enumerator.new(self,:each_foreign_key,model)
        end

        model.relationships.each_value do |relationship|
          next if relationship.respond_to?(:through)

          case relationship
          when Associations::ManyToOne::Relationship,
               Associations::OneToOne::Relationship
            yield relationship.child_key.first.name,
                  relationship.parent_model
          end
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
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      def each_relationship
        return Enumerator.new(self,:each_relationship) unless block_given?

        each_model do |model|
          model.relationships.each_value do |relationship|
            unless relationship.respond_to?(:through)
              yield relationship, model
            end
          end
        end
      end

      protected

      #
      # Prints a message to `STDERR`.
      #
      # @param [String] message
      #   The message to print.
      #
      def log(message)
        STDERR.puts "dm-visualizer: #{message}"
      end

    end
  end
end
