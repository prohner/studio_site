require 'spec_helper'

describe MasterTermGroup do
  before(:each) do
    @style      = Factory(:master_style)
    @federation = Factory(:master_federation)
    @attr       = { :master_federation => @federation, :name => "blocks", :name_translated => "mahk kee" }
  end

  it "should be valid given good attributes" do
    MasterTermGroup.new(@attr).should be_valid
  end

  #it "should have a unique name" do
  #  MasterTermGroup.create!(@attr)
  #  MasterTermGroup.new(@attr).should_not be_valid
  #end

  it "should not have an excessively long name" do
    @attr = { :name => 'x' * 251 }
    MasterTermGroup.new(@attr).should_not be_valid
  end

  it "should not allow an empty name" do
    @attr = { :name => '   ' }
    MasterTermGroup.new(@attr).should_not be_valid
  end
  
  it "should respond to terms" do
    mtg = MasterTermGroup.new(@attr)
    mtg.should respond_to(:master_terms)
  end

  it "should respond to master federation" do
    mtg = MasterTermGroup.new(@attr)
    mtg.should respond_to(:master_federation)
  end

  describe "term associations" do
    before(:each) do
      @style  = Factory(:master_style, :name => "tang soo do")
      @fed1   = Factory(:master_federation, :master_style => @style, :name => "1 fed")
      @tg1    = Factory(:master_term_group, :master_federation => @fed1, :name => "1 term group")
      @term1  = Factory(:master_term, :master_term_group => @tg1, :term => "1 term")
      @term2  = Factory(:master_term, :master_term_group => @tg1, :term => "1 term")
    end
  
    it "should respond to master terms" do
      @tg1.should respond_to(:master_terms)
    end
    
    it "should have the right term groups in the right order" do
      @tg1.master_terms.should == [@term1, @term2]
    end
    
    it "should destroy associated term groups" do
      @tg1.destroy
      [@term1, @term2].each do |tg|
        MasterTermGroup.find_by_id(tg.id).should be_nil
      end
    end
  end
end
# == Schema Information
#
# Table name: master_term_groups
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  name_translated      :string(255)
#  master_style_id      :integer
#  master_federation_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

