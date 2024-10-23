class ApplicationController < ActionController::Base

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user
  before_action :set_devise_mapping
  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:utype, :name, :phone, :dob, :address, :profile])
    devise_parameter_sanitizer.permit(:account_update, keys: [:utype, :name, :phone, :dob, :address, :profile])
  end



  # def create_link
  #   if user_signed_in?
  #     link_to "Create", posts_path, class: "nav-link"
  #   else
  #     link_to "Create", new_user_registration_path, class: "nav-link"
  #   end
  # end
  
  private

  def set_devise_mapping
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  private

  def set_user
    @user = current_user
  end
  
  # for showing login or not 
  private

  def authenticate_user!
    if !current_user
      flash[:notice] = 'You need to sign in or sign up before continuing.'
      redirect_to new_user_session_path
    end
  end 
end
