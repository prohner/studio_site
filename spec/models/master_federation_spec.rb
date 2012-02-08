require 'spec_helper'

describe MasterFederation do
  before(:each) do
    @style = Factory(:master_style)
    @attr = { :master_style => @style, :name => "hwa rang" }
  end
  
  it "should respond to a master style" do
    mf = MasterFederation.new(@attr)
    mf.should respond_to(:master_style)
  end

  it "should be valid given good attributes" do
    MasterFederation.new(@attr).should be_valid
  end

  it "should have a unique name" do
    MasterFederation.create!(@attr)
    MasterFederation.new(@attr).should_not be_valid
  end

  it "should not have an excessively long name" do
    @attr = { :name => 'x' * 251 }
    MasterFederation.new(@attr).should_not be_valid
  end

  it "should not allow an empty name" do
    @attr = { :name => '   ' }
    MasterFederation.new(@attr).should_not be_valid
  end
  
  it "should respond to term groups" do
    mf = MasterFederation.new(@attr)
    mf.should respond_to(:master_term_groups)
  end

  describe "term group associations" do
    before(:each) do
      @style  = Factory(:master_style, :name => "tang soo do")
      @fed1   = Factory(:master_federation, :master_style => @style, :name => "1 fed")
      @tg1    = Factory(:master_term_group, :master_federation => @fed1, :name => "1 term group")
      @tg2    = Factory(:master_term_group, :master_federation => @fed1, :name => "2 term group")
    end
  
    it "should respond to master term groups" do
      @fed1.should respond_to(:master_term_groups)
    end
    
    it "should have the right term groups in the right order" do
      @fed1.master_term_groups.should == [@tg1, @tg2]
    end
    
    it "should destroy associated term groups" do
      @fed1.destroy
      [@tg1, @tg2].each do |tg|
        MasterTermGroup.find_by_id(tg.id).should be_nil
      end
    end
  end
end
# == Schema Information
#
# Table name: master_federations
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  master_style_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

