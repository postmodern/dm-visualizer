require 'rake/tasklib'

module DataMapper
  module Visualizer
    module Rake
      class Task < ::Rake::TaskLib

        # Options for the DataMapper Visualizer.
        attr_reader :options

        #
        # Creates a new task.
        #
        # @param [Hash] options
        #   Options for the DataMapper Visualizer.
        #
        # @yield [task]
        #   The given block will be passed the newly created task.
        #   
        # @yieldparam [Task] task
        #   The new Task.
        #
        def initialize(options={})
          @options = {
            :bundle => File.file?('Gemfile')
          }
          @options.merge!(options)

          yield self if block_given?

          define()
        end

        #
        # Defines a task within the `dm:doc` namespace.
        #
        def define(&block)
          namespace :dm do
            namespace(:doc,&block)
          end

          task 'db:doc' => 'dm:doc'
        end

      end
    end
  end
end
