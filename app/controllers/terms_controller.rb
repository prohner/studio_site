class TermsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :new]

  def new
    @title = "Add Term"
    @current_style = Style.find(:first, :conditions => ["id = ? and studio_id = ?", current_style_id, params[:id]])
    @current_style = Style.find(:first, :conditions => ["id = ? and studio_id = ?", 1,1])
    @term_groups = @current_style.term_groups
    @new_term = Term.new
  end
  
  def create
    term_group = TermGroup.find_by_id(params[:term][:term_group_id])
    term = term_group.terms.build(params[:term])
    if term.save
      flash[:success] = "Term created"
      redirect_to :controller => :studios, :action => :show, :id => term_group.style.studio.id, :style_id => term_group.style.id
    else
      render 'pages/home'
    end
  end

  def destroy
    term = Term.find_by_id(params[:id]).destroy
    flash[:success] = "Term destroyed."
    redirect_to :controller => :studios, :action => :show, :id => term.term_group.style.studio.id, :style_id => term.term_group.style.id
  end
end
