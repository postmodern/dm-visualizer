require 'spec_helper'

shared_examples_for "a Ruby project" do
  it "should add the include directories to the $LOAD_PATH" do
    subject.activate!

    subject.include_dirs.all? { |dir|
      $LOAD_PATH.include?(dir)
    }.should == true
  end

  it "should remove the include directories to the $LOAD_PATH" do
    subject.deactivate!

    subject.include_dirs.all? { |dir|
      $LOAD_PATH.include?(dir)
    }.should == false
  end
end
