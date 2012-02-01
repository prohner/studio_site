class StudiosController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def new
    @studio = Studio.new
    @title = signup_form_name
  end
  
  def index
    @studios = Studio.all
    @title = "All Studios"
  end
  
  def show
    @studio = Studio.find(params[:id])
    @title = @studio.name
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
  
  private
  
    def signup_form_name
      "Sign Up"
    end
    
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @studio = Studio.find(params[:id])
      redirect_to(root_path) unless current_studio?(@studio)
    end
end
