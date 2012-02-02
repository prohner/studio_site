require 'spec_helper'

describe TermGroup do
  before(:each) do
    @studio = Factory(:studio)
    @style = @studio.styles.create!( :name => "tang soo do" )
    @attr = { :name => "blocking techniques" }
  end
  
  it "should create a new instrance given valid attributes" do
    @style.term_groups.create!(@attr)
  end

  describe "validations" do
    it "should require a style id" do
      TermGroup.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @style.term_groups.build(:name => "   ").should_not be_valid
    end
    
    it "should reject long content" do
      @style.term_groups.build(:name => "a" * 251).should_not be_valid
    end
  end    

  describe "style associations" do
    before(:each) do
      @term_group = @style.term_groups.create(@attr)
    end
    
    it "should have a user attribute" do
      @term_group.should respond_to(:style)
    end
    
    it "should have the right associated style" do
      @term_group.style_id.should == @style.id
      @term_group.style.should == @style
    end
  end
  
  describe "term associations" do
    before(:each) do
      @term_group = @style.term_groups.create(@attr)
      @term2 = Factory(:term, :term_group => @term_group, :term => "2 term")
      @term1 = Factory(:term, :term_group => @term_group, :term => "1 term")
    end
    
    it "should have a terms attribute" do
      @term_group.should respond_to(:terms)
    end
    
    it "should have the right terms in the right order" do
      @term_group.terms.should == [@term1, @term2]
    end
  end
end

# == Schema Information
#
# Table name: term_groups
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  style_id          :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  phonetic_spelling :string(255)
#  name_translated   :string(255)
#

