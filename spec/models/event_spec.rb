require 'spec_helper'

describe Event do  
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :title => "title of event", :starts_at => "2/12/2012 09:00", :ends_at => "2/12/2012 10:00", :studio => @studio }
  end

  specify { Event.new(@attr).should be_valid }
  specify { Event.new(@attr).should respond_to(:studio) }
  specify { Event.new(@attr).should respond_to(:edit_url) }
  specify { Event.new(@attr).should respond_to(:title) }
  specify { Event.new(@attr).should respond_to(:description) }
  specify { Event.new(@attr).should respond_to(:starts_at) }
  specify { Event.new(@attr).should respond_to(:ends_at) }
  
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

  describe "HTML colors" do
    it "should respond to HTML_color_names" do
      Event.should respond_to(:HTML_color_names)
    end

    it "should return a hash of valid HTML color names" do
      Event.HTML_color_names.class.should == Hash
    end

    it "should have at least 4 color names" do
      Event.HTML_color_names.length.should > 3
    end
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

