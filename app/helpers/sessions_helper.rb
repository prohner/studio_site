module SessionsHelper
    
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def sign_in(studio)
    cookies.permanent.signed[:remember_token] = [studio.id, studio.salt]
    self.current_studio = studio
  end
  
  def current_studio?(studio)
    studio == @current_studio
  end

  def current_studio=(studio)
    @current_studio = studio
  end
  
  def current_studio
    @current_studio ||= studio_from_remember_token
  end

  def set_the_current_style_id(style)
    if style.nil?
      session[:current_style_id] = nil
    else
      session[:current_style_id] = style.id
    end
  end

  def current_style_id=(style)
    session[:current_style_id] = style.id
  end
  
  def current_style_id
    session[:current_style_id]
  end
  
  def signed_in?
    !current_studio.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_studio = nil
  end
  
  private
    def studio_from_remember_token
      Studio.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
end
