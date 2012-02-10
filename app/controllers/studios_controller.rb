class StudiosController < ApplicationController
  before_filter :authenticate,  :only => [:index, :edit, :update]
  before_filter :correct_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only => :destroy

  def new
    @studio = Studio.new
    @title = signup_form_name
  end
  
  def index
    @studios = Studio.paginate(:page => params[:page])
    @title = "All Studios"
  end
  
  def show
    @studio = Studio.find(params[:id])
    @title = @studio.name
    @new_style = Style.new
    @new_term_group = TermGroup.new
    @new_term = Term.new
    
    if params[:style_id].nil?
      style = @studio.styles.first
      unless style.nil?
        style_id = style.id
      end
    else
      style_id = params[:style_id]
    end

    @current_style = Style.find(:first, :conditions => ["id = ? and studio_id = ?", style_id, params[:id]])
    @term_groups = @current_style.term_groups unless @current_style.nil?
    
    set_the_current_style_id(@current_style)
    current_studio
    
  end
  
  def create
    @studio = Studio.new(params[:studio])
    if @studio.save
      sign_in @studio
      flash[:success] = "Welcome and thanks for signing up!"
      redirect_to @studio
    else
      @title = signup_form_name
      render 'new'
    end
  end
  
  def edit
    @title = "Edit Studio"
  end
  
  def update
    @studio = Studio.find(params[:id])
    if @studio.update_attributes(params[:studio])
      flash[:success] = "Profile updated."
      redirect_to @studio
    else
      @title = "Edit studio"
      render 'edit'
    end
  end
  
  def destroy
    Studio.find(params[:id]).destroy
    flash[:success] = "Studio destroyed."
    redirect_to studios_path
  end
  
  private
  
    def signup_form_name
      "Sign Up"
    end
    
    def correct_user
      @studio = Studio.find(params[:id])
      redirect_to(root_path) unless current_studio?(@studio)
    end
    
    def admin_user
      if current_studio.nil? or not current_studio.admin?
        redirect_to(signin_path) 
      end
    end
end
