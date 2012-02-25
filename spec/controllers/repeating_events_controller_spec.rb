require 'spec_helper'

describe RepeatingEventsController do
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :title => "title of event", :studio_id => @studio.id, :on_monday => true, :studio => @studio, :repetition_type => 'weekly', :starts_at => "2/12/2012 09:00", :ends_at => "2/12/2012 10:00" }
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      ev = RepeatingEvent.create!(@attr)
      get 'edit', :id => ev.id
      response.should be_success
    end
    it "should have a calendar entry header area when showing the edit form"
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "returns http success" do
      ev = Factory(:repeating_event, @attr)
      @vars = { :id => ev.id,
                :repeating_event => {
                  :title => "some title",
                  :starts_at => "2/2/2012 09:00",
                  :ends_at => "2/2/2012 10:00",
                  :description => "whatever",
                  :repetition_type => "weekly",
                  :on_monday => true
                   }
              }

      get 'update', @vars
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

end
