class StudiosController < ApplicationController
  def new
    @title = "Sign Up"
  end
  
  def show
    @studio = Studio.find(params[:id])
  end
end
