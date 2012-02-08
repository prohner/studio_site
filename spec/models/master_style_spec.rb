require 'spec_helper'

describe MasterStyle do
  before(:each) do
    @attr = { :name => "tang soo do" }
  end
  
  it "should create a new instance given valid attributes" do
    MasterStyle.new(@attr).should be_valid
  end

  it "should not allow an excessively long name" do
    @attr = { :name => 'x' * 51 }
    MasterStyle.new(@attr).should_not be_valid
  end
  
  it "should not allow an empty name" do
    @attr = { :name => '   ' }
    MasterStyle.new(@attr).should_not be_valid
  end
  
  it "should not allow duplicate names" do
    MasterStyle.create!(@attr)
    MasterStyle.new(@attr).should_not be_valid
  end
  
  it "should respond to master term groups" do
    style = MasterStyle.create!(@attr)
    style.should_not respond_to(:master_term_groups)
  end
  
  describe "federation associations" do
    before(:each) do
      @style = MasterStyle.create!(@attr)
      @fed1 = Factory(:master_federation, :master_style => @style, :name => "1 fed")
      @fed2 = Factory(:master_federation, :master_style => @style, :name => "2 fed")
    end
  
    it "should respond to master federations" do
      @style.should respond_to(:master_federations)
    end
    
    it "should have the right federations in the right order" do
      @style.master_federations.should == [@fed1, @fed2]
    end
    
    it "should destroy associated term groups" do
      @style.destroy
      [@fed1, @fed2].each do |tg|
        MasterFederation.find_by_id(tg.id).should be_nil
      end
    end
  end
end
# == Schema Information
#
# Table name: master_styles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

