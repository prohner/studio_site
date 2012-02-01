class StudiosController < ApplicationController
  def new
    @studio = Studio.new
    @title = signup_form_name
  end
  
  def show
    @studio = Studio.find(params[:id])
    @title = @studio.name
  end
  
  def create
    @studio = Studio.new(params[:studio])
    if @studio.save
      flash[:success] = "Welcome and thanks for signing up!"
      redirect_to @studio
    else
      @title = signup_form_name
      render 'new'
    end
  end
  
  private
  
    def signup_form_name
      "Sign Up"
    end
end
