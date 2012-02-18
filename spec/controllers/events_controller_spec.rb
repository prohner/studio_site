require 'spec_helper'

describe EventsController do
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :title => "title of event", 
      :starts_at => "2/12/2012 09:00", 
      :ends_at => "2/12/2012 10:00",
      :studio => @studio
      }
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    
    it "should return the right events within a timeframe"
    it "should not return events outside the timeframe"
    it "should include repeating events that are within the timeframe"
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      @vars = { :calendar => { :id => "", :the_working_day => "2/2/2012 09:00" }, 
                :class_name => "class", 
                :class_description => "whatever",
                :studio_id => @studio.id }
      get 'new', @vars
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "returns http success" do
      ev = Factory(:event, @attr)
      @vars = { :id => ev.id,
                :event => { 
                  :starts_at => "2/2/2012 09:00",
                  :ends_at => "2/2/2012 10:00",
                  :description => "whatever"
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
