require 'spec_helper'

describe StudiosController do
  render_views
  
  describe "GET 'show'" do
    before(:each) do
      @studio = Factory(:studio)
    end
    
    it "should be successful" do
      get :show, :id => @studio
      response.should be_success
    end
    
    it "should find the right studio" do
      get :show, :id => @studio
      assigns(:studio).should == @studio
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign Up")
    end
  end

end
