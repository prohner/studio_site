require 'spec_helper'

describe MasterTerm do
  before(:each) do
    @style      = Factory(:master_style)
    @federation = Factory(:master_federation)
    @term_group = Factory(:master_term_group)
    @attr       = {:master_term_group => @term_group, :term => "ha dan mahk kee", :term_translated => "low block" }
  end

  it "should be valid given good attributes" do
    MasterTerm.new(@attr).should be_valid
  end

  it "should not have an excessively long term" do
    @attr = { :term => 'x' * 251 }
    MasterTerm.new(@attr).should_not be_valid
  end

  it "should not have an excessively long term translated" do
    @attr = { :term_translated => 'x' * 251 }
    MasterTerm.new(@attr).should_not be_valid
  end

  it "should not have a blank long term" do
    @attr = { :term => '   ' }
    MasterTerm.new(@attr).should_not be_valid
  end

  it "should not have a blank long term translated" do
    @attr = { :term_translated => '   ' }
    MasterTerm.new(@attr).should_not be_valid
  end

  it "should respond to term groups" do
    term = MasterTerm.new(@attr)
    term.should respond_to(:master_term_group)
  end

end
# == Schema Information
#
# Table name: master_terms
#
#  id                   :integer         not null, primary key
#  term                 :string(255)
#  term_translated      :string(255)
#  description          :text
#  master_term_group_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

