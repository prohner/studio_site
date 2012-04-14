class TermLibraryController < ApplicationController
  def show_styles
    do_it
  end

  def show_federations
    do_it
  end

  def show_term_groups
    do_it
  end

  def show_terms
    do_it
  end
  
  private 
    def do_it
      @styles = MasterStyle.all
      @master_style_id = nil
      @master_federation_id = nil
      @master_term_group_id = nil
      @federation = nil

      if not params[:master_style_id].nil?
        @master_style_id = params[:master_style_id]
      elsif not params[:master_federation_id].nil?
        @federation = MasterFederation.find(params[:master_federation_id])
        @master_style_id = @federation.master_style_id
      elsif not params[:master_term_group_id].nil?
        @term_group = MasterTermGroup.find(params[:master_term_group_id])
        @federation = @term_group.master_federation
        @master_style_id = @federation.master_style_id
      end
      
      if not @master_style_id.nil?
        @style = MasterStyle.find(@master_style_id)
      end

      if not @style.nil? 
        @federations = @style.master_federations
      end
      
      if not @federation.nil?
        @master_federation_id = @federation.id
        @term_groups = MasterTermGroup.find(:all, :conditions => ["master_federation_id = ?", @federation.id])
      end
      
      if not @term_group.nil?
        @master_term_group_id = @term_group.id
        @terms = @term_group.master_terms
      end
    end
end
