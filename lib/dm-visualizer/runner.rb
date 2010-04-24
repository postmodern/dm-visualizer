require 'dm-serializer/graphviz'

require 'thor'

module DataMapper
  module Visualizer
    class Runner < Thor

      desc 'graphviz PATH', 'Generates a GraphViz diagram'
      common_options
      method_option :format, :type => :string, :aliases => '-F'
      method_option :colors, :type => :hash
      method_option :labels, :type => :hash
      def graphviz(path)
        DataMapper::Visualizer::GraphViz.new(
          path,
          options
        ).visualize
      end

      protected

      def self.common_options
        method_option :include, :type => :array, :aliases => '-I'
        method_option :require, :type => :array, :aliases => '-r'
        method_option :require_all, :type => :array, :aliases => '-R'
      end

    end
  end
end
