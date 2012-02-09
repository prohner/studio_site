class MasterDataController < ApplicationController
  def show_styles
    @title = "Styles Template"
    @styles = MasterStyle.all
  end

  def show_federations
    master_style = MasterStyle.find(params[:master_style_id])
    @federations = master_style.master_federations
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js
    end
  end

  def show_term_groups
  end
end
