require 'spec_helper'

describe CalendarController do
  render_views

  before(:each) do
    @studio = Factory(:studio)
  end

  describe "GET 'index'" do
    before(:each) do
      test_sign_in(@studio)
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
  end

end
