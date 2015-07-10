module DataMapper
  module Visualizer
    module Rake
      module Padrino
        module Tasks
          #
          # Disables Bundler by default.
          #
          def initialize(options={},&block)
            super({:bundle => false}.merge(options),&block)
          end

          #
          # Overrides the Rake `task` method to make sure every defined
          # task depends on `environment`.
          #
          # @param [Array] arguments
          #   The arguments of the task.
          #
          def task(*arguments)
            if arguments.first.kind_of?(Hash)
              super(*arguments)
            else
              super(arguments.first => :environment)
            end
          end
        end
      end
    end
  end
end
