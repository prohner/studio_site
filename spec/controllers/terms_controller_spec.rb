require 'spec_helper'

describe TermsController do
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
      @studio     = test_sign_in(Factory(:studio))
      @style      = Factory(:style, :studio => @studio, :name => "style name")
      @term_group = Factory(:term_group, :style => @style, :name => "blocks")
      controller.set_the_current_style_id(@style)
    end

    describe "failure" do
      before(:each) do
        @attr = { :term => "" }
      end
      
      it "should not create a term" do
        lambda do
          post :create, :term => @attr, :term_group_id => @term_group.id
        end.should_not change(Term, :count)
      end
      
      it "should render the home page" do
        post :create, :term => @attr, :term_group_id => @term_group.id
        response.should render_template('pages/home')
      end
    end
  end
end
