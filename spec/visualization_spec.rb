require 'dm-visualizer/visualization'

require 'spec_helper'
require 'helpers/project'

describe DataMapper::Visualizer::Visualization do
  include Helpers::Project

  it "should detect which inflector DataMapper is using" do
    DataMapper::Visualizer::Visualization::Inflector.should_not be_nil
  end

  describe "defaults" do
    before(:all) do
      @vis = DataMapper::Visualizer::Visualization.new(
        :include => [File.join(project_dir('library'),'lib')],
        :require => ['blog']
      )
    end

    it "should return the class names of Classes" do
      @vis.class_name(Blog::User).should == 'User'
    end

    it "should return the class names of Objects" do
      @vis.class_name(Blog::Post.body).should == 'Property'
    end

    it "should return the names of properties" do
      @vis.property_name(Blog::Post.body).should == 'body'
    end

    it "should return the names of models" do
      @vis.model_name(Blog::User).should == 'User'
    end
  end

  describe "repository names" do
    before(:all) do
      @vis = DataMapper::Visualizer::Visualization.new(
        :include => [File.join(project_dir('library'),'lib')],
        :require => ['blog'],
        :repository_names => {:default => 'blogdb'}
      )
    end

    it "should map the DataMapper repository names" do
      @vis.model_repository_name(Blog::User).should == 'blogdb'
    end
  end

  describe "SQL style" do
    before(:all) do
      @vis = DataMapper::Visualizer::Visualization.new(
        :include => [File.join(project_dir('library'),'lib')],
        :require => ['blog'],
        :repository_names => {:default => 'blogdb'},
        :style => :sql
      )
    end

    it "should return the database and table names for a model name" do
      @vis.model_name(Blog::User).should == 'blogdb.blog_users'
    end
  end

  describe "full names" do
    before(:all) do
      @vis = DataMapper::Visualizer::Visualization.new(
        :include => [File.join(project_dir('library'),'lib')],
        :require => ['blog'],
        :full_names => true
      )
    end

    it "should not demodulize the names of Classes" do
      @vis.class_name(Blog::User).should == 'Blog::User'
    end

    it "should not demodulize the names of Objects" do
      @vis.class_name(Blog::Post.body).should == 'DataMapper::Property'
    end

    it "should not demodulize property type names" do
      @vis.property_type_name(Blog::Post.body).should == 'DataMapper::Types::Text'
    end

    it "should not demodulize model names" do
      @vis.model_name(Blog::User).should == 'Blog::User'
    end
  end
end
