require 'spec_helper'

describe EventsController do
  render_views
  
  before(:each) do
    @studio = Factory(:studio)
    @attr = { :title => "title of event", 
      :starts_at => "2/12/2012 09:00", 
      :ends_at => "2/12/2012 10:00",
      :studio => @studio
      }
  end

  describe "GET 'index'" do
    before(:each) do
      @ev1       = Event.create!( :title => "ev1", 
                                  :studio => @studio,
                                  :starts_at => "2/15/2012 00:00:01", 
                                  :ends_at => "2/15/2012 23:59:59")
      @ev2       = Event.create!( :title => "ev2", 
                                  :studio => @studio,
                                  :starts_at => "2/16/2012 00:00:01", 
                                  :ends_at => "2/16/2012 23:59:59")
      @ev_during = Event.create!( :title => "ev during", 
                                  :studio => @studio,
                                  :starts_at => "2/15/2012 00:00:01", 
                                  :ends_at => "2/15/2012 23:59:59")
      @ev_before = Event.create!( :title => "ev before", 
                                  :studio => @studio,
                                  :starts_at => "1/31/2012 00:00:01", 
                                  :ends_at => "1/31/2012 23:59:59")
      @ev_after = Event.create!(  :title => "ev after", 
                                  :studio => @studio,
                                  :starts_at => "3/1/2012 00:00:01", 
                                  :ends_at => "3/1/2012 23:59:59")
                                  
      @february_repeater = RepeatingEvent.create!(  :title => "title of event", 
                                                    :on_monday => true, 
                                                    :studio => @studio, 
                                                    :repetition_type => 'weekly', 
                                                    :starts_at => "1/1/2012 09:00", 
                                                    :ends_at => "2/29/2012 10:00" )
                                  
      @vars = { :start => DateTime.strptime("2012-02-01 00:00:00", "%Y-%m-%d %H:%M:%S").to_time.to_i,
                :end => DateTime.strptime("2012-02-29 23:59:59", "%Y-%m-%d %H:%M:%S").to_time.to_i}
      get 'index', @vars
    end
    
    it "returns http success" do
      response.should be_success
    end
    
    it "should have a new event to edit" do
      assigns[:event].should_not be_nil
    end
    
    it "should return the right events within a timeframe" do
      assigns[:events].should include(@ev1)
      assigns[:events].should include(@ev2)
      assigns[:events].should include(@ev_during)
    end
    
    it "should not return events outside the timeframe" do
      assigns[:events].should_not include(@ev_before)
      assigns[:events].should_not include(@ev_after)
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
      @vars = { :calendar => { :id => "", :the_working_day => "2/2/2012 09:00" }, 
                :class_name => "class", 
                :class_description => "whatever",
                :studio_id => @studio.id }
      get 'new', @vars
      response.should be_success
    end
    
    it "should respond to URL for AJAX call" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @ev1       = Event.create!( :title => "ev1", 
                                  :studio => @studio,
                                  :starts_at => "2/15/2012 00:00:01", 
                                  :ends_at => "2/15/2012 23:59:59")
    end
    
    it "returns http success" do
      get 'edit', :id => @ev1.id
      response.should be_success
      assigns[:event].should == @ev1
    end

    it "should have a calendar entry header area when showing the edit form" do
      get 'edit', :id => @ev1.id
      response.should have_selector("#calendar_entry_header")
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
                  :title => "some title",
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
