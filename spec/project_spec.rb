require 'dm-visualizer/project'

require 'spec_helper'
require 'helpers/project'
require 'project_examples'

describe DataMapper::Visualizer::Project do
  include Helpers::Project

  context "library" do
    before(:all) do
      @dir = project_dir('library')
      @project = DataMapper::Visualizer::Project.new(
        :include => [File.join(@dir,'lib')],
        :require => ['library']
      )
    end

    it_should_behave_like "a Ruby project"
  end

  context "rails" do
    before(:all) do
      @dir = project_dir('rails')
      @project = DataMapper::Visualizer::Project.new(
        :include => [@dir],
        :require_all => ['app/models/*.rb']
      )
    end

    it_should_behave_like "a Ruby project"
  end
end
