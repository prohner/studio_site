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
      @other_studio = Factory(:studio, :email => Factory.next(:email))
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
      @ev_other = Event.create!(  :title => "Other Studio Event", 
                                  :studio => @other_studio,
                                  :starts_at => "2/15/2012 00:00:01", 
                                  :ends_at => "2/15/2012 23:59:59")
                                  
      @february_repeater = RepeatingEvent.create!(  :title => "title of event", 
                                                    :on_monday => true, 
                                                    :studio => @studio, 
                                                    :repetition_type => 'weekly', 
                                                    :starts_at => "1/1/2012 09:00", 
                                                    :ends_at => "2/29/2012 10:00" )
                                  
      @vars = { :id => @studio.id,
                :start => DateTime.strptime("2012-02-01 00:00:00", "%Y-%m-%d %H:%M:%S").to_time.to_i,
                :end => DateTime.strptime("2012-02-29 23:59:59", "%Y-%m-%d %H:%M:%S").to_time.to_i}
      get 'index', @vars
    end
    
    #it "should not return results without a studio id" do
    #  lambda {
    #    @vars = { :id => nil,
    #              :start => DateTime.strptime("2012-02-01 00:00:00", "%Y-%m-%d %H:%M:%S").to_time.to_i,
    #              :end => DateTime.strptime("2012-02-29 23:59:59", "%Y-%m-%d %H:%M:%S").to_time.to_i}
    #    get 'index', @vars
    #  }.should raise_error(ActionController::RoutingError)    
    #end

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
    
    it "should show calendar events for only one studio at a time" do
      assigns[:events].should_not include(@ev_other)
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
    before(:each) do
      @vars = { :id => nil,
                :starts_at => "2/2/2012 09:00",
                :ends_at => "2/2/2012 10:00",
                :event => {
                  :title => "some title",
                  :description => "whatever"
                   }
              }
    end

    it "should fail without sign in" do
      controller.sign_out
      get 'create', @vars
      response.should redirect_to(root_path)
    end
    
    describe "when signed in" do
      before(:each) do
        test_sign_in(@studio)
      end

      it "returns http success" do
        get 'create', @vars
        response.should be_success
      end

      it "should add an event" do
        lambda do
          get 'create', @vars
        end.should change(Event, :count).by(1)
      end
    
      it "must have a studio id" do
        controller.current_studio.id.nil?.should be_false
      
      end
    end
  end

  describe "GET 'update'" do
    before(:each) do
      @ev = Factory(:event, @attr)
    end
    
    it "should accept times from time_select" do
      vars = {  :id => @ev.id,
                :starts_at => {"starts_at(1i)"=>"2012", "starts_at(2i)"=>"2", "starts_at(3i)"=>"29", "starts_at(4i)"=>"06", "starts_at(5i)"=>"15"},
                :ends_at => {"ends_at(1i)"=>"2012", "ends_at(2i)"=>"2", "ends_at(3i)"=>"29", "ends_at(4i)"=>"06", "ends_at(5i)"=>"45"},
                :event => {
                  :title => "some title",
                  :description => "whatever"
                }
              }
      get 'update', vars
      response.should be_success
    end
    
    it "should accept times straight in" do
      vars = {  :id => @ev.id,
                :event => {
                  :title => "some title",
                  :description => "whatever",
                  :starts_at => "2012-02-29 09:00:00",
                  :ends_at => "2012-02-29 10:00:00"
                   }
              }

      get 'update', vars
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
