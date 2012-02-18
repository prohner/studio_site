class MasterDataController < ApplicationController
  def show_styles
    @title  = page_title
    @style  = nil
    @styles = MasterStyle.all
    @target_term_group_id = params[:target_term_group_id]
    #puts "Our term group is #{@target_term_group_id}"
  end

  def show_federations
    @title        = page_title
    @style        = MasterStyle.find(params[:master_style_id])
    @styles       = MasterStyle.all
    @federations  = @style.master_federations
    @target_term_group_id = params[:target_term_group_id]
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js
    end
  end

  def show_term_groups
    @title        = page_title
    @style        = MasterStyle.find(params[:master_style_id])
    @styles       = MasterStyle.all
    @target_term_group_id = params[:target_term_group_id]

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
    @target_term_group_id = params[:target_term_group_id]

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
  
  def copy_terms
    @terms = MasterTerm.find(params[:terms][:id])
    term_group = TermGroup.find(params[:target_term_group_id])

    @terms.each do |term|
      puts term.term
      new_term = Term.new
      new_term.term = term.term
      new_term.term_translated = term.term_translated
      new_term.description = term.description
      new_term.term_group = term_group
      new_term.save!
    end
    
    redirect_to :controller => 'studios', :action => 'show', :id => term_group.style.studio.id, :style_id => term_group.style.id
  end
  
  private
    def page_title
      "Styles Template"
    end
end
