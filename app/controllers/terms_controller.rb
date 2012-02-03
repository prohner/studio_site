class TermsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]

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
  end
end
