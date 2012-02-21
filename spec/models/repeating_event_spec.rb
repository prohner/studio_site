require 'spec_helper'

describe RepeatingEvent do
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :title => "title of event", :on_monday => true, :studio => @studio, :repetition_type => 'weekly', :starts_at => "2/12/2012 09:00", :ends_at => "2/12/2012 10:00" }
  end

  it "should be valid given valid attributes" do
    ev = RepeatingEvent.new(@attr)
    ev.should be_valid
  end
  
  it "should respond to studio" do
    ev = RepeatingEvent.new(@attr)
    ev.should respond_to(:studio)
  end
  
  it "should be able to cough up its own edit URL" do
    ev = RepeatingEvent.new(@attr)
    ev.should respond_to(:edit_url)
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
  
  it "should require starts_at precedes ends_at" do
    ev = RepeatingEvent.new(@attr.merge(:starts_at => "2/1/2012",:ends_at => "1/1/2012"))
    ev.should_not be_valid
  end
  
  
  describe "repetition settings" do
    before(:each) do
      @ev = RepeatingEvent.new(@attr)
    end
    
    it "should accept good repetition types" do
      @ev.repetition_type = "weekly"
      @ev.on_monday = true
      @ev.should be_valid

      @ev.repetition_type = "monthly"
      @ev.should be_valid
    end

    it "should reject a weekly setting with no day" do
      @ev.repetition_type = "weekly"
      @ev.on_sunday = false
      @ev.on_monday = false
      @ev.on_tuesday = false
      @ev.on_wednesday = false
      @ev.on_thursday = false
      @ev.on_friday = false
      @ev.on_saturday = false
      @ev.should_not be_valid
    end
    
    it "should reject bad repetition types" do
      @ev.repetition_type = "yearly"
      @ev.should_not be_valid
    end
    
    #it "should reject bad repetition frequency values" do
    #  @ev.repetition_frequency = 0
    #  @ev.should_not be_valid

    #  @ev.repetition_frequency = 2
    #  @ev.should_not be_valid
    #end
    
    #it "should deal nicely with weekly repetitions" do
    #  @ev.repetition_frequency = 1
    #  @ev.should     be_valid
    #end
  end

  describe "when building events for timeframe" do
    it "should create the correct number of events"
    it "should create the correct number of events"
    it "should not create any events out of timeframe"
  end
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
#  repetition_type      :string(255)
#  repetition_frequency :integer
#  on_sunday            :boolean
#  on_monday            :boolean
#  on_tuesday           :boolean
#  on_wednesday         :boolean
#  on_thursday          :boolean
#  on_friday            :boolean
#  on_saturday          :boolean
#  repetition_options   :string(255)
#  studio_id            :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

