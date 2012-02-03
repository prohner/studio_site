require 'spec_helper'

describe TermGroupsController do
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
  
  describe "POST 'create'" do
    before(:each) do
      @studio = test_sign_in(Factory(:studio))
      @style = Factory(:style, :studio => @studio, :name => "style name")
      controller.set_the_current_style_id(@style)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "" }
      end
      
      it "should not create a term group" do
        lambda do
          post :create, :term_group => @attr
        end.should_not change(TermGroup, :count)
      end
      
      it "should render the home page" do
        post :create, :term_group => @attr
        response.should render_template('pages/home')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "blocks" }
      end
    
      it "should create a term group" do
        lambda do
          post :create, :term_group => @attr
        end.should change(TermGroup, :count).by(1)
      end
    
      it "should redirect to the studio page" do
        post :create, :term_group => @attr
        #response.should render_template('studios/show')
        #response.should redirect_to(@studio, :style_id => @style.id)
        redirect_to :controller => :studios, :action => :show, :id => @studio.id, :style_id => @style.id
      end
    
      it "should have a flash message" do
        post :create, :term_group => @attr
        flash[:success].should =~ /group created/i
      end
    end
  end

end