require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    studio = Factory(:studio)
    visit edit_studio_path(studio)
    fill_in :email,     :with => studio.email
    fill_in :password,  :with => studio.password
    click_button
    response.should render_template('studios/edit')
  end
end
