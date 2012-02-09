class MasterDataController < ApplicationController
  def show_styles
    @title = "Styles Template"
    @styles = MasterStyle.all
  end

  def show_federations
  end

  def show_term_groups
  end
end
