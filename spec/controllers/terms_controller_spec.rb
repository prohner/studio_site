require 'spec_helper'

describe TermsController do
  render_views
  
  describe "access control" do
    it "should deny access to 'create'" do
      get :new
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'edit'" do
      get :edit
      response.should redirect_to(signin_path)
    end

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
          post :create, :term => @attr, :term => {"term_group_id" => @term_group.id}
        end.should_not change(Term, :count)
      end
      
      it "should render the home page" do
        post :create, :term => @attr, :term => {"term_group_id" => @term_group.id}
        response.should render_template('pages/home')
      end
    end
  end
  
  describe "GET 'new'" do
    before(:each) do
      @studio     = test_sign_in(Factory(:studio))
      @style      = Factory(:style, :studio => @studio, :name => "style name")
      @term_group = Factory(:term_group, :style => @style, :name => "blocks")
      controller.set_the_current_style_id(@style)
    end

    it "should be successful" do
      get :new, :term_group_id => @term_group.id, :style_id => @style.id, :studio_id => @studio.id
      response.should be_success
    end
    
    it "should have the right title" do
      get :new, :term_group_id => @term_group.id, :style_id => @style.id, :studio_id => @studio.id
      response.should have_selector("title", :content => "Add")
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @studio     = test_sign_in(Factory(:studio))
      @style      = Factory(:style,       :studio => @studio,         :name => "style name")
      @term_group = Factory(:term_group,  :style => @style,           :name => "blocks")
      @term       = Factory(:term,        :term_group => @term_group, :term => "inside outside")
    end
    
    it "should be successful" do
      get :edit, :id => @term.id
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @term.id
      response.should have_selector("title", :content => "Edit")
      response.should have_selector("title", :content => @term.term)
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @studio     = test_sign_in(Factory(:studio))
      @style      = Factory(:style,       :studio => @studio,         :name => "style name")
      @term_group = Factory(:term_group,  :style => @style,           :name => "blocks")
      @term       = Factory(:term,        :term_group => @term_group, :term => "inside outside")
    end
    
    it "should save the changed term" do
      new_term    = "another term"
      @term.term  = new_term
      put :update, :id => @term.id, :term => { :term => new_term }
      @term.reload
      @term.term.should == new_term

    end
  end
end
