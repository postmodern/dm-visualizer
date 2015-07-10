require 'dm-visualizer/rake/padrino/tasks'
require 'dm-visualizer/rake/graphviz_task'

module DataMapper
  module Visualizer
    module Rake
      module Padrino
        class GraphVizTask < Rake::GraphVizTask

          include Tasks

        end
      end
    end
  end
end
