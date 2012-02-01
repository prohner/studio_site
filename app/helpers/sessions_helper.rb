module SessionsHelper
  def sign_in(studio)
    cookies.permanent.signed[:remember_token] = [studio.id, studio.salt]
    self.current_studio = studio
  end
  
  def current_studio=(studio)
    @current_studio = studio
  end
  
  def current_studio
    @current_studio ||= studio_from_remember_token
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
end
