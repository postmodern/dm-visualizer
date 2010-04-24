require 'dm-visualizer/project'

shared_examples_for "a Ruby project" do
  context "loading" do
    it "should add the include directories to the $LOAD_PATH" do
      @project.activate!

      @project.include_dirs.all? { |dir|
        $LOAD_PATH.include?(dir)
      }.should == true
    end

    it "should remove the include directories to the $LOAD_PATH" do
      @project.deactivate!

      @project.include_dirs.all? { |dir|
        $LOAD_PATH.include?(dir)
      }.should == false
    end
  end

  context "requiring" do
  end
end
