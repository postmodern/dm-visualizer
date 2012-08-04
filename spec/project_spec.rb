require 'spec_helper'
require 'project_examples'

require 'dm-visualizer/project'

describe DataMapper::Visualizer::Project do
  context "library" do
    let(:dir) { project_dir('library') }

    subject do
      described_class.new(
        :include => [File.join(dir,'lib')],
        :require => ['blog']
      )
    end

    it_should_behave_like "a Ruby project"

    it "should require the specified paths" do
      subject.load!

      Object.should be_const_defined('Blog')
    end
  end

  context "rails" do
    let(:dir) { project_dir('rails') }

    subject do
      described_class.new(
        :include     => [dir],
        :require_all => ['app/models/*.rb']
      )
    end

    it_should_behave_like "a Ruby project"

    it "should require all paths that match the specified glob patterns" do
      subject.load!

      Object.should be_const_defined('User')
      Object.should be_const_defined('Post')
      Object.should be_const_defined('Comment')
    end
  end
end
