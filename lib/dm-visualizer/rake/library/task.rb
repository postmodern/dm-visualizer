require 'rake'

module DataMapper
  module Visualizer
    module Rake
      module Library
        class Task < ::Rake::TaskLib
          # The default options to pass to a new {Visualization}
          DEFAULT_OPTIONS = {
            :include => ['ext', 'lib'],
            :bundle => [:runtime]
          }

          #
          # Creates a new task.
          #
          # @yield [task]
          #   The given block will be passed the newly created task.
          #   
          # @yieldparam [Task] task
          #   The new Task.
          #
          def initialize(options={})
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
          end

        end
      end
    end
  end
end
