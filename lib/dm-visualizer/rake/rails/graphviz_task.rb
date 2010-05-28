require 'dm-visualizer/rake/rails/tasks'
require 'dm-visualizer/rake/graphviz_task'

module DataMapper
  module Visualizer
    module Rake
      module Rails
        class GraphVizTask < Rake::GraphVizTask

          include Tasks

        end
      end
    end
  end
end
