require 'spec_helper'
require 'helpers/project'

require 'dm-visualizer/visualization'

describe DataMapper::Visualizer::Visualization do
  let(:lib_dir) { File.join(project_dir('library'),'lib') }

  before(:all) do
    $LOAD_PATH << lib_dir
    require 'blog'
  end

  context "defaults" do
    it "should return the class names of Classes" do
      subject.class_name(Blog::User).should == 'User'
    end

    it "should return the class names of Objects" do
      subject.class_name(Blog::Post.body).should == 'Text'
    end

    it "should return the names of properties" do
      subject.property_name(Blog::Post.body).should == 'body'
    end

    it "should return the names of models" do
      subject.model_name(Blog::User).should == 'User'
    end
  end

  context "with repository names" do
    subject { described_class.new(:repository_names => {:default => 'blogdb'}) }

    it "should map the DataMapper repository names" do
      subject.model_repository_name(Blog::User).should == 'blogdb'
    end
  end

  context "with schema naming convention" do
    subject do
      described_class.new(
        :repository_names => {:default => 'blogdb'},
        :naming           => :schema
      )
    end

    it "should return the database and table names for a model name" do
      subject.model_name(Blog::User).should == 'blogdb.blog_users'
    end
  end

  context "with full names" do
    subject { described_class.new(:full_names => true) }

    it "should not demodulize the names of Classes" do
      subject.class_name(Blog::User).should == 'Blog::User'
    end

    it "should not demodulize the names of Objects" do
      object = Blog::Post.new

      subject.class_name(object).should == 'Blog::Post'
    end

    it "should not demodulize property type names" do
      subject.property_type_name(Blog::Post.body).should =~ /::Text$/
    end

    it "should not demodulize model names" do
      subject.model_name(Blog::User).should == 'Blog::User'
    end
  end

  after(:all) { $LOAD_PATH.delete(lib_dir) }
end
