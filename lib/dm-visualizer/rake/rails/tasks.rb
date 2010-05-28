module DataMapper
  module Visualizer
    module Rake
      module Rails
        module Tasks
          #
          # Overrides the Rake `task` method to make sure every defined
          # task depends on `dm:load_models`.
          #
          # @param [Array] arguments
          #   The arguments of the task.
          #
          def task(*arguments)
            if arguments.first.kind_of?(Hash)
              super(*arguments)
            else
              super(arguments.first => 'db:load_models')
            end
          end
        end
      end
    end
  end
end
