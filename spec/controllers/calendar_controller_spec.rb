require 'spec_helper'

describe CalendarController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      get 'index'
    end
    
    it "returns http success" do
      response.should be_success
    end
    
    it "should create a new event" do
      assigns[:event].should_not be_nil
    end
    
    it "should have a calendar form container" do
      response.should have_selector('div.calendar_entry')
    end
    
    it "should show calendar events for only one studio at a time"
  end

end
