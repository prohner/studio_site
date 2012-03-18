require 'spec_helper'

describe WebServicesController do

  describe "GET 'studios'" do
    before (:each) do
      @studios = []
      5.times do
        @studios << Factory(:studio, :name => Factory.next(:name), :email => Factory.next(:email))
      end
    end
    
    it "returns http success" do
      get 'studios'
      response.should be_success
    end
    
    it "should return all the studios" do
      get 'studios'
      @studios.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      assigns[:studios].should == @studios
    end
    

    it "should retrieve a JSON object" do
      get 'studios', :format => :json
      @studios.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      response.body.should == @studios.to_json
    end

  end

  describe "GET 'events'" do
    it "returns http success" do
      get 'events'
      response.should be_success
    end
  end

  describe "GET 'repeating_events'" do
    it "returns http success" do
      get 'repeating_events'
      response.should be_success
    end
  end

  describe "GET 'terminology'" do
    it "returns http success" do
      get 'terminology'
      response.should be_success
    end
  end

end
