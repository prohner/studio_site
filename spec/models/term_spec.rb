require 'spec_helper'

describe Term do
  before(:each) do
    @studio = Factory(:studio)
    @style = @studio.styles.create!( :name => "tang soo do" )
    @term_group = @style.term_groups.create!( :name => "blocking techniques" )
    @attr = { :term => "ahneso phakuro" }
  end
  
  it "should create a new instrance given valid attributes" do
    @term_group.terms.create!(@attr)
  end
  
  describe "validations" do
    before(:each) do
      @term = @term_group.terms.create(@attr)
    end

    it "should require a term group id" do
      Term.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @term_group.terms.build(:term => "   ").should_not be_valid
    end
    
    it "should reject long term" do
      @term_group.terms.build(:term => "a" * 251).should_not be_valid
    end
     
    it "should reject long term translation" do
      @term_group.terms.build(:term => "ahneso phakuro", :term_translated => "x" * 251).should_not be_valid
    end

    it "should reject long phonetic spelling" do
      @term_group.terms.build(:term => "ahneso phakuro", :phonetic_spelling => "x" * 251).should_not be_valid
    end
    
    it "should have a term translated attribute" do
      @term.should respond_to(:term_translated)
    end
    
    it "should have a phonetic spelling attribute" do
      @term.should respond_to(:phonetic_spelling)
    end
  end    

  describe "term associations" do
    before(:each) do
      @term = @term_group.terms.create(@attr)
    end
    
    it "should have a term group attribute" do
      @term.should respond_to(:term_group)
    end
    
    it "should have the right associated term group" do
      @term.term_group_id.should == @term_group.id
      @term.term_group.should == @term_group
    end
  end
end
# == Schema Information
#
# Table name: terms
#
#  id                :integer         not null, primary key
#  term              :string(255)
#  term_translated   :string(255)
#  description       :text
#  phonetic_spelling :string(255)
#  term_group_id     :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

