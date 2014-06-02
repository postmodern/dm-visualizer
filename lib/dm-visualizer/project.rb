require 'set'
require 'dm-core'

module DataMapper
  module Visualizer
    #
    # Defines the paths and directories to load for a DataMapper project.
    #
    class Project

      # Specifies which Bundler groups to activate.
      attr_reader :bundle

      # The directories to include
      attr_reader :include_dirs

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
      # @option options [Enumerable, Symbol, String, Boolean] :bundle
      #   Specifies which groups of dependencies to activate using Bundler.
      #
      # @option options [Array] :require
      #   The paths to require.
      #
      # @option options [Array] :require_all
      #   The path globs to require.
      #
      def initialize(options={})
        @bundle = Set[]
        @include_dirs = Set[]
        @require_paths = Set[]
        @require_globs = Set[]

        if options[:include]
          options[:include].each do |dir|
            @include_dirs << File.expand_path(dir)
          end
        end

        case options[:bundle]
        when String, Symbol
          @bundle << options[:bundle].to_sym
        when Enumerable
          options[:bundle].each do |group|
            @bundle << group.to_sym
          end
        when true
          @bundle << :default
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
        rescue LoadError
          log "Gemfile exists, but bundler is not installed"
          log "Run `gem install bundler` to install bundler."
        end

        begin
          Bundler.require(*@bundle)
        rescue Bundler::BundlerError => error
          log error.message
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
        bundle! unless @bundle.empty?

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
          rescue LoadError => error
            log "dm-visualizer: unable to load #{path}"
            log "dm-visualizer: #{error.message}"
          end
        end

        @require_globs.each do |glob|
          @include_dirs.each do |dir|
            Dir[File.join(dir,glob)].each do |path|
              relative_path = path[(dir.length + 1)..-1]

              begin
                require relative_path
              rescue LoadError => error
                log "dm-visualizer: unable to load #{relative_path} from #{dir}"
                log "dm-visualizer: #{error.message}"
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
        return enum_for(:each_model_inheritence) unless block_given?

        each_model do |model|
          direct_ancestor = model.ancestors[1]

          if direct_ancestor.class == Class
            yield model, direct_ancestor
          end
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
        return enum_for(:each_foreign_key,model) unless block_given?

        # XXX: in dm-core 1.1.0, `Model#relationships` returns a
        # `DataMapper::RelationshipSet`, instead of a `Mash`, which does
        # not provide the `each_value` method.
        each_relationship_for(model) do |relationship|
          case relationship
          when Associations::ManyToOne::Relationship,
               Associations::OneToOne::Relationship
            yield relationship.child_key.first.name,
                  relationship.parent_model
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
        return enum_for(:each_property,model) unless block_given?

        foreign_keys = Set[]

        each_foreign_key(model) do |name,parent_model|
          foreign_keys << name
        end
        
        model.properties.each do |property|
          yield property unless foreign_keys.include?(property.name)
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
        return enum_for(:each_relationship) unless block_given?

        each_model do |model|
          each_relationship_for(model) do |relationship|
            yield relationship, model
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
        warn "dm-visualizer: #{message}"
      end

      #
      # Enumerates over each DataMapper relationship in a model.
      #
      # @yield [relationship]
      #   The given block will be passed each relationship in the model.
      #
      # @yieldparam [DataMapper::Relationship] relationship
      #   A relationship.
      #
      # @since 0.2.1
      #
      def each_relationship_for(model)
        # XXX: in dm-core 1.1.0, `Model#relationships` returns a
        # `DataMapper::RelationshipSet`, instead of a `Mash`, which does
        # not provide the `each_value` method.
        model.relationships.each do |args|
          relationship = case args
                         when Array
                           args.last
                         else
                           args
                         end

          unless relationship.respond_to?(:through)
            yield relationship
          end
        end
      end

    end
  end
end
