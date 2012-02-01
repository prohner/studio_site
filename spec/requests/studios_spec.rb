require 'spec_helper'

describe "Studios" do
  describe "signup" do
    describe "failure" do
      it "should not make a new studio" do
        visit signup_path
        fill_in "Name",         :with => ""
        fill_in "Email",        :with => ""
        fill_in "Password",     :with => ""
        fill_in "Confirmation", :with => ""
        click_button
        response.should render_template('studios/new')
        response.should have_selector("div#error_explanation")
      end
    end
    
    describe "success" do
      it "should make a new studio" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "example"
          fill_in "Email",        :with => "abc@def.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should render_template('studios/show')
          response.should have_selector("div.flash.success", :content => "Welcome")
          controller.should be_signed_in
        end.should change(Studio, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a studio in" do
        visit signin_path
        fill_in :email,     :with => ""
        fill_in :password,  :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
    
    describe "success" do
      it "should sign a studio in and out" do
        studio = Factory(:studio)
        visit signin_path
        fill_in :email,     :with => studio.email
        fill_in :password,  :with => studio.password
        click_button
        controller.should be_signed_in
        click_link "Sign Out"
        controller.should_not be_signed_in
      end
    end
  end
end
