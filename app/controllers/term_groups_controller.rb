class TermGroupsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :new]
  
  def new
    @title = "Add Term Group"
    @current_style = Style.find(:first, :conditions => ["id = ? and studio_id = ?", current_style_id, params[:id]])
    
    @new_term_group = TermGroup.new
  end
  
  def create
    style = Style.find(current_style_id)
    @term_group = style.term_groups.build(params[:term_group])
    if @term_group.save
      flash[:success] = "Term group created"
      redirect_to :controller => :studios, :action => :show, :id => style.studio.id, :style_id => current_style_id
    else
      render 'pages/home'
    end
  end

  def destroy
  end
  
  def show
    @term_group = TermGroup.find(params[:id])
    respond_to do |format|
      format.json { render :json => @term_group.terms }
    end

  end
end
