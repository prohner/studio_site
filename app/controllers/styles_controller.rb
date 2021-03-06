class StylesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def index
    
  end
  
  def create
    @style = current_studio.styles.build(params[:style])
    if @style.save
      flash[:success] = "Style created"
      redirect_to current_studio
    else
      render 'pages/home'
    end
  end

  def destroy
  end
  
  def show
    @style = Style.find_by_id(params[:id])
    respond_to do |format|
      format.json { render :json => @style.term_groups }
    end
  end
  
end
