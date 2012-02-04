require 'spec_helper'

describe StylesController do
  render_views
  
  describe "access control" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'JSON'" do
    before(:each) do
      @studio = test_sign_in(Factory(:studio))
      @style = Factory(:style, :studio => @studio, :name => "style name")
      @term_group_name = "term group"
      @term_group = Factory(:term_group, :style => @style, :name => @term_group_name)
    end
    
    it "should retrieve a JSON object" do
      get :get, :style => @style, :format => :json
      response.body.should == [@term_group].to_json
    end
  end
  
  
  describe "POST 'create'" do
    before(:each) do
      @studio = test_sign_in(Factory(:studio))
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "" }
      end
      
      it "should not create a style" do
        lambda do
          post :create, :style => @attr
        end.should_not change(Style, :count)
      end
      
      it "should render the home page" do
        post :create, :style => @attr
        response.should render_template('pages/home')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "tang soo" }
      end
    
      it "should create a style" do
        lambda do
          post :create, :style => @attr
        end.should change(Style, :count).by(1)
      end
    
      it "should redirect to the home page" do
        post :create, :style => @attr
        response.should redirect_to(@studio)
      end
    
      it "should have a flash message" do
        post :create, :style => @attr
        flash[:success].should =~ /style created/i
      end
    end
  end
end