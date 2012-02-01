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
    
    it "should have the right title" do
      get :show, :id => @studio
      response.should have_selector("title", :content => @studio.name)
    end
    
    it "should include the studio's name" do
      get :show, :id => @studio
      response.should have_selector("h1", :content => @studio.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @studio
      response.should have_selector("h1>img", :class => "gravatar")
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

  describe "POST 'create'" do
    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "abc@def.com", :password => "foobar1", :password_confirmation => "foobar1" }
      end
      
      it "should redirect to the user show page" do
        post :create, :studio => @attr
        response.should redirect_to(studio_path(assigns(:studio)))
      end

      it "should create a user" do
        lambda do
          post :create, :studio => @attr
        end.should change(Studio, :count).by(1)
      end
      
      it "should have a welcome message" do
        post :create, :studio => @attr
        flash[:success].should =~ /welcome/i
      end
      
      it "should sign the studio in" do
        post :create, :studio => @attr
        controller.should be_signed_in
      end
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :studio => @attr
        end.should_not change(Studio, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign Up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  end
end
