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
      #@studios.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      #response.body.should == @studios.to_json
      response.should be_success
      pending "Validate sort order and json content"
    end

  end

  describe "GET 'events'" do
    before (:each) do
      @studio = Factory(:studio)
    end
    
    it "returns http success" do
      get 'events', :format => :json, :id => @studio.id
      response.should be_success
    end
  end

  describe "GET 'repeating_events'" do
    before (:each) do
      @studio = Factory(:studio)
    end
    
    it "returns http success" do
      get 'repeating_events', :format => :json, :id => @studio.id
      response.should be_success
    end
  end

  describe "GET 'terminology'" do
    before (:each) do
      @studio = Factory(:studio)
      @style = Factory(:style, :studio => @studio, :name => "style name")
    end
    
    it "returns http success" do
      get 'terminology', :format => :json, :id => @style.id
      response.should be_success
    end
  end

end
