require 'dm-visualizer'

require 'spec_helper'

describe DataMapper::Visualizer do
  it "should define a VERSION constant" do
    DataMapper::Visualizer.const_defined?('VERSION').should == true
  end
end
