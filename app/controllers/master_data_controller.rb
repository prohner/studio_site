class MasterDataController < ApplicationController
  def show_styles
    @title  = page_title
    @style  = nil
    @styles = MasterStyle.all
  end

  def show_federations
    @title        = page_title
    @style        = MasterStyle.find(params[:master_style_id])
    @styles       = MasterStyle.all
    @federations  = @style.master_federations
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js
    end
  end

  def show_term_groups
    @title        = page_title
    @style        = MasterStyle.find(params[:master_style_id])
    @styles       = MasterStyle.all

    @federations  = @style.master_federations
    @federation   = MasterFederation.find(params[:master_federation_id])
    @term_groups  = @federation.master_term_groups
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js
    end
  end

  def show_terms
    @title        = page_title
    @style        = MasterStyle.find(params[:master_style_id])
    @styles       = MasterStyle.all

    @federations  = @style.master_federations
    @federation   = MasterFederation.find(params[:master_federation_id])
    @term_group   = MasterTermGroup.find(params[:master_term_group_id])
    @term_groups  = @federation.master_term_groups
    @terms        = @term_group.master_terms
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js
    end
  end
  
  private
    def page_title
      "Styles Template"
    end
end
