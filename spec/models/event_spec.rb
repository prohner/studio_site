require 'spec_helper'

describe Event do  
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :title => "title of event", :starts_at => "2/12/2012 09:00", :ends_at => "2/12/2012 10:00", :studio => @studio }
  end

  it "should be valid given valid attributes" do
    ev = Event.new(@attr)
    ev.should be_valid
  end
  
  it "should respond to studio" do
    ev = Event.new(@attr)
    ev.should respond_to(:studio)
  end
  
  it "should be able to cough up its own edit URL" do
    ev = Event.new(@attr)
    ev.should respond_to(:edit_url)
  end
  
  it "should require a title" do
    ev = Event.new(@attr.merge(:title => ""))
    ev.should_not be_valid
  end
  
  it "should require a starts_at" do
    ev = Event.new(@attr.merge(:starts_at => nil))
    ev.should_not be_valid
  end
  
  it "should require a ends_at" do
    ev = Event.new(@attr.merge(:ends_at => nil))
    ev.should_not be_valid
  end
  
  it "should require starts_at precedes ends_at" do
    ev = Event.new(@attr.merge(:starts_at => "2/1/2012",:ends_at => "1/1/2012"))
    ev.should_not be_valid
  end

  it "should titles that are too long" do
    ev = Event.new(@attr.merge(:title => "a" * 51))
    ev.should_not be_valid
  end
  
  it "should have to belong to a studio" do
    ev = Event.new(@attr.merge(:studio_id => nil))
    ev.should_not be_valid
  end
end
# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  starts_at   :datetime
#  ends_at     :datetime
#  all_day     :boolean
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  studio_id   :integer
#

