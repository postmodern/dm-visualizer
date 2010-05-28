require 'dm-visualizer/rake/graphviz_task'

module DataMapper
  module Visualizer
    module Rake
      module Rails
        class GraphVizTask < Rake::GraphVizTask

          #
          # Defines the `dm:doc:graphviz` namespace.
          #
          def define
            super do
              namespace :graphviz do
                desc 'Generates a GraphViz relational diagram of the DataMapper Models'
                task :relational  => 'db:load_models' do
                  @relational.visualize!
                end

                desc 'Generates a GraphViz schema diagram of the DataMapper Models'
                task :schema  => 'db:load_models' do
                  @schema.visualize!
                end
              end

              task :graphviz => ['graphviz:relational', 'graphviz:schema']
            end
          end

        end
      end
    end
  end
end
