require 'dm-visualizer/graphviz'

require 'thor'

module DataMapper
  module Visualizer
    class Runner < Thor

      def self.common_options
        method_option :include, :type => :array, :aliases => '-I'
        method_option :require, :type => :array, :aliases => '-r'
        method_option :require_all, :type => :array, :aliases => '-R'
        method_option :repository_names, :type => :hash
        method_option :style, :type => :string
        method_option :full_names, :type => :boolean
      end

      desc 'graphviz', 'Generates a GraphViz diagram'
      common_options
      method_option :file, :type => :string, :aliases => '-f'
      method_option :format, :type => :string, :aliases => '-F'
      method_option :colors, :type => :hash
      method_option :labels, :type => :hash
      def graphviz
        DataMapper::Visualizer::GraphViz.new(options).visualize!
      end

    end
  end
end
