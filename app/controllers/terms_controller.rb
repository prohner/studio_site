class TermsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :new, :edit, :update]

  def new
    @title = "Add Term"
    
    @current_style = Style.find(:first, :conditions => ["id = ? and studio_id = ?", params[:style_id], params[:studio_id]])
    @term_groups = @current_style.term_groups
    @selected_term_group_id = params[:term_group_id]
    @term = Term.new
  end
  
  def edit
    @term = Term.find(params[:id])
    @title = "Edit #{@term.term}"
    @term_groups = @term.term_group.style.term_groups
    @selected_term_group_id = @term.term_group.id
  end
  
  def update
    term = Term.find(params[:id])
    if term.update_attributes(params[:term])
      flash[:success] = "Term saved"
      redirect_to :controller => :studios, :action => :show, :id => term.term_group.style.studio.id, :style_id => term.term_group.style.id
    end
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
