require 'spec_helper'

describe MasterDataController do
  render_views
  
  describe "GET" do
    before(:each) do
      @style      = Factory(:master_style)
      @federation = Factory(:master_federation, :master_style_id => @style.id)
      @term_group = Factory(:master_term_group, :master_federation_id => @federation.id)
    end
    
    describe "'show_styles'" do
      it "returns http success" do
        get :show_styles
        response.should be_success
      end

      it "should have the right title" do
        get 'show_styles'
        response.should have_selector("title", :content => "Styles")
      end    
    end

    describe "'show_federations'" do
      it "returns http success" do
        get 'show_federations', :master_style_id => 1
        response.should be_success
      end
    end

    describe "'show_term_groups'" do
      it "returns http success" do
        get 'show_term_groups', :master_style_id => 1, :master_federation_id => 1
        response.should be_success
      end
    end
  end
end
