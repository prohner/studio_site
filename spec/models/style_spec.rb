require 'spec_helper'

describe Style do
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :name => "tang soo do" }
  end
  
  it "should create a new instance given valid attributes" do
    @studio.styles.create!(@attr)
  end
  
  describe "validations" do
    it "should require a user id" do
      Style.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @studio.styles.build(:name => "   ").should_not be_valid
    end
    
    it "should reject long content" do
      @studio.styles.build(:name => "a" * 51).should_not be_valid
    end
  end
  
  describe "studio associations" do
    before(:each) do
      @style = @studio.styles.create(@attr)
    end
    
    it "should have a user attribute" do
      @style.should respond_to(:studio)
    end
    
    it "should have the right associated studio" do
      @style.studio_id.should == @studio.id
      @style.studio.should == @studio
    end
  end
  
  describe "term group associations" do
    before(:each) do
      @style = @studio.styles.create(@attr)
      @tg2 = Factory(:term_group, :style => @style, :name => "2 term group")
      @tg1 = Factory(:term_group, :style => @style, :name => "1 term group")
    end
    
    it "should have a term group attribute" do
      @style.should respond_to(:term_groups)
    end
    
    it "should have the right term groups in the right order" do
      @style.term_groups.should == [@tg1, @tg2]
    end
  end
end
# == Schema Information
#
# Table name: styles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  studio_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

