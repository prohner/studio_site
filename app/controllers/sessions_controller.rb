class SessionsController < ApplicationController
  def new
    @title = signin_form_name
  end
  
  def create
    studio = Studio.authenticate( params[:session][:email],
                                  params[:session][:password])
    if studio.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = signin_form_name
      render :new
    else
      sign_in studio
      redirect_back_or studio
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
  
    def signin_form_name
      "Sign In"
    end
end
