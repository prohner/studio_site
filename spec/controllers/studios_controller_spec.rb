require 'spec_helper'

describe StudiosController do
  render_views
  
  describe "authentication of edit/update pages" do
    before(:each) do
      @studio = Factory(:studio)
    end
    
    describe "for non-signed-in studios" do
      it "should deny access to 'edit'" do
        get :edit, :id => @studio
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @studio, :studio => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in studios" do
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
        
        30.times do
          @studios << Factory(:studio, :name => Factory.next(:name), :email => Factory.next(:email))
        end
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
        @studios[0..2].each do |studio|
          response.should have_selector("li", :content => studio.name)
        end
      end
      
      it "should paginate studios"do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/studios?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/studios?page=2",
                                           :content => "Next")      
      end
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @studio = Factory(:studio)
      @style  = Factory(:style, :studio => @studio)
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
      
      it "should change the studio's attributes" do
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
    
    describe "studio's styles" do
      before(:each) do
        @style1 = Factory(:style, :studio => @studio, :name => "tang soo")
        @style2 = Factory(:style, :studio => @studio, :name => "judo")
      end
      
      it "should show the studio's styles" do
        get :show, :id => @studio
        response.should have_selector("span.style", :content => @style1.name)
        response.should have_selector("span.style", :content => @style2.name)
      end
    
      it "should show the current style" do
        get :show, :id => @studio, :style_id => @style1.id
        response.should have_selector("div.current_style", :content => @style1.name)
      end
    
      it "should not be able to show someone else's style" do
        other_studio = Factory(:studio, :email => "other@wherever.com")
      
        other_style = Factory(:style, :studio => other_studio, :name => "tang soo")
        get :show, :id => @studio, :style_id => other_style.id
        response.should_not have_selector("span.current_style", :content => other_style.name)
      end
    
      describe "term groups and terms" do
        before(:each) do
          @tg1 = Factory(:term_group, :style => @style1, :name => "blocks")
          @tg2 = Factory(:term_group, :style => @style1, :name => "kicks")
          @tg3 = Factory(:term_group, :style => @style2, :name => "strikes")
          
          @term1 = Factory(:term, :term_group => @tg1, :term => "inside outside")
          @term2 = Factory(:term, :term_group => @tg1, :term => "outside inside")
        end
        
        it "should show the current style's term group and terms" do
          get :show, :id => @studio, :style_id => @style1.id
          response.should have_selector("div.term_group", :content => @tg1.name)
          response.should have_selector("div.term_group", :content => @tg2.name)
        end
        
        it "should show the current style's term group and terms" do
          get :show, :id => @studio, :style_id => @style1.id
          response.should have_selector("span.term_term", :content => @term1.term)
          response.should have_selector("span.term_term", :content => @term1.term)
        end
        
        describe "studio's own pages" do
          before(:each) do
            test_sign_in(@studio)
          end

          it "should allow the studio to add its own group of terms" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => new_term_group_path)
          end

          it "should allow the studio to import terms from templates" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => master_data_show_styles_path(:target_term_group_id => @tg1.id))
          end

          it "should allow the studio to delete a term group" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => term_group_path)
          end

          it "should allow the studio to delete a term" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => term_path)
          end

          it "should allow the studio to add a term" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => new_term_path(:term_group_id => @tg1.id, :style_id => @tg1.style.id, :studio_id => @tg1.style.studio.id))
          end

          it "should allow the studio to edit a term" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => edit_term_path(@term1))
          end

          it "should allow the studio to edit a term group" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should have_selector("a", :href => edit_term_group_path(@tg1))
          end
        end

        describe "other studios' pages" do
          before(:each) do
            @other_studio = Factory(:studio, :email => "other@wherever.com")
            test_sign_in(@other_studio)
          end
          
          it "should not allow one studio to change another's content" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => new_term_group_path)
          end

          it "should not allow one studio to import terms from templates" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => master_data_show_styles_path(:target_term_group_id => @tg1.id))
          end

          it "should not allow one studio to delete another's a term group" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => term_group_path)
          end

          it "should not allow one studio to delete another's a term" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => term_path)
          end

          it "should not allow one studio to add a term to another" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => new_term_path(:term_group_id => @tg1.id, :style_id => @tg1.style.id, :studio_id => @tg1.style.studio.id))
          end

          it "should not allow one studio to edit another's term" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => edit_term_path(@term1))
          end

          it "should not allow one studio to edit another's term group" do
            get :show, :id => @studio, :style_id => @style1.id
            response.should_not have_selector("a", :href => edit_term_group_path(@tg1))
          end
        end
      end
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
        post :create, :studio => @attr
        response.should have_selector("title", :content => "Sign Up")
      end
      
      it "should render the 'new' page" do
        post :create, :studio => @attr
        response.should render_template('new')
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @studio = Factory(:studio)
    end
    
    describe "as a non-signed-in studio" do
      it "should deny access" do
        delete :destroy, :id => @studio
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin studio" do
      it "should protect the page" do
        test_sign_in(@studio)
        delete :destroy, :id => @studio
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as an admin studio" do
      before(:each) do
        admin = Factory(:studio, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      it "should destroy the studio" do
        lambda do
          delete :destroy, :id => @studio
        end.should change(Studio, :count).by(-1)
      end
      
      it "should redirect to the studios page" do
        delete :destroy, :id => @studio
        response.should redirect_to(studios_path)
      end
    end
  end
end
