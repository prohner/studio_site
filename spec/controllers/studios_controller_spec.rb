require 'spec_helper'

describe StudiosController do
  render_views
  
  describe "authentication of edit/update pages" do
    before(:each) do
      @studio = Factory(:studio)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @studio
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @studio, :studio => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        wrong_studio = Factory(:studio, :email => "bad@email.com")
        test_sign_in(wrong_studio)
      end
      
      it "should require matching studio for 'edit'" do
        get :edit, :id => @studio
        response.should redirect_to(root_path)
      end
      
      it "should require matching studio for 'update'" do
        put :update, :id => @studio, :studio => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "GET 'index'" do
    describe "for non-signed-in studios" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed-in studios" do
      before(:each) do
        @studio   = test_sign_in(Factory(:studio))
        second    = Factory(:studio, :name => "Bill", :email => "lmno@pqrs.com")
        third     = Factory(:studio, :name => "Tom",  :email => "asdf@pqrs.com")
        @studios  = [@studio, second, third]
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All Studios")
      end
      
      it "should have an element for each studio" do
        get :index
        @studios.each do |studio|
          response.should have_selector("li", :content => studio.name)
        end
      end
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @studio = Factory(:studio)
      test_sign_in(@studio)
    end
    
    it "should be successful" do
      get :edit, :id => @studio
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @studio
      response.should have_selector("title", :content => "Edit")
    end
    
    it "should have a link to change the Gravatar" do
      get :edit, :id => @studio
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                          :content => "change")
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @studio = Factory(:studio)
      test_sign_in(@studio)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :email => "", :name => "", :password => "", :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @studio, :studio => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @studio, :studio => @attr
        response.should have_selector("title", :content => "Edit")
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :email => "abc@def.com", :name => "ali baba", :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @studio, :studio => @attr
        @studio.reload
        @studio.name.should   == @attr[:name]
        @studio.email.should  == @attr[:email]
      end
    end
  end
  
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
