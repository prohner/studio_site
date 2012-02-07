class TermGroupsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :new, :update]
  
  def new
    @title = "Add Term Group"
    @current_style = Style.find(:first, :conditions => ["id = ? and studio_id = ?", current_style_id, params[:id]])
    
    @term_group = TermGroup.new
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

  def edit
    @term_group = TermGroup.find(params[:id])
    @title = "Edit #{@term_group.name}"
    @term_groups = @term_group.style.term_groups
    @selected_term_group_id = @term_group.id
  end

  def update
    term_group = TermGroup.find(params[:id])
    if term_group.update_attributes(params[:term_group])
      flash[:success] = "Group saved"
      redirect_to :controller => :studios, :action => :show, :id => term_group.style.studio.id, :style_id => term_group.style.id
    end
  end
  

  def destroy
    term_group = TermGroup.find(params[:id])
    term_group.destroy
    flash[:success] = "Studio destroyed."
    redirect_to :controller => :studios, :action => :show, :id => term_group.style.studio.id, :style_id => term_group.style.id
  end
  
  def show
    @term_group = TermGroup.find(params[:id])
    respond_to do |format|
      format.json { render :json => @term_group.terms }
    end

  end
end
