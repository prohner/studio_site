require 'spec_helper'

describe MasterDataController do
  render_views
  
  describe "GET 'show_styles'" do
    it "returns http success" do
      get :show_styles
      response.should be_success
    end

    it "should have the right title" do
      get 'show_styles'
      response.should have_selector("title", :content => "Styles")
    end    
  end

  describe "GET 'show_federations'" do
    it "returns http success" do
      get 'show_federations'
      response.should be_success
    end
  end

  describe "GET 'show_term_groups'" do
    it "returns http success" do
      get 'show_term_groups'
      response.should be_success
    end
  end

end
