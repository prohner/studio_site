require 'spec_helper'

describe RepeatingEvent do
  before(:each) do
    @attr = { :title => "title of event", :starts_at => "2/12/2012 09:00", :ends_at => "2/12/2012 10:00" }
  end

  it "should respond to studio" do
    ev = RepeatingEvent.new(@attr)
    ev.should respond_to(:studio)
  end
  
  it "should require a title" do
    ev = RepeatingEvent.new(@attr.merge(:title => nil))
    ev.should_not be_valid
  end

  it "should titles that are too long" do
    ev = RepeatingEvent.new(@attr.merge(:title => "a" * 51))
    ev.should_not be_valid
  end
  
  it "should have to belong to a studio" do
    ev = RepeatingEvent.new(@attr.merge(:studio_id => nil))
    ev.should_not be_valid
  end
  
  it "should have a valid repetition frequency and options" 
end
# == Schema Information
#
# Table name: repeating_events
#
#  id                   :integer         not null, primary key
#  title                :string(255)
#  starts_at            :datetime
#  ends_at              :datetime
#  all_day              :boolean
#  description          :text
#  repetition_frequency :integer
#  repetition_options   :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  studio_id            :integer
#

