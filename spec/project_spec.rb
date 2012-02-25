require 'dm-visualizer/project'

require 'spec_helper'
require 'project_examples'

describe DataMapper::Visualizer::Project do
  context "library" do
    before(:all) do
      @dir = project_dir('library')
      @project = DataMapper::Visualizer::Project.new(
        :include => [File.join(@dir,'lib')],
        :require => ['blog']
      )
    end

    it_should_behave_like "a Ruby project"

    it "should require the specified paths" do
      @project.load!

      Object.const_defined?('Blog').should == true
    end
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

    it "should require all paths that match the specified glob patterns" do
      @project.load!

      Object.const_defined?('User').should == true
      Object.const_defined?('Post').should == true
      Object.const_defined?('Comment').should == true
    end
  end
end
