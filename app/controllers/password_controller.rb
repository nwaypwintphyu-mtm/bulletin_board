class PasswordController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in

  def edit
    render 'user/change_password'
  end



def update
  @old = password_params[:old_password]
  @new = password_params[:new_password]
  @newconfirm = password_params[:new_password_confirmation]
  has_errors = false

  if @old.empty?
    current_user.errors.add(:old_password, "Current password can't be blank")
    has_errors = true
  end

  if @new.empty?
    current_user.errors.add(:new_password, "New password can't be blank")
    has_errors = true
  end

  if @newconfirm.empty?
    current_user.errors.add(:new_password_confirmation, "New confirm password can't be blank")
    has_errors = true
  end

  if has_errors
    render 'user/change_password' and return
  end

  if current_user.valid_password?(@old)
    if @new == @newconfirm
      current_user.password = @new
      if  current_user.update_attribute(:password, @new) && 
          current_user.update_attribute(:password_confirmation, @newconfirm) 

          redirect_to new_user_session_path, notice: "Hello \"#{current_user.name}\", Password updated successfully. Please login again."
      else
        current_user.errors.add(:base, "Password update fails!")
        render 'user/change_password'
      end
    else
      current_user.errors.add(:notmatch, "New password and new confirm password are not match!")
      render 'user/change_password'
    end
  else
    current_user.errors.add(:wrong, "Current password is wrong!")
    render 'user/change_password'
  end
end


  private
  
  def password_params
    params.require(:user).permit(:old_password, :new_password, :new_password_confirmation)
  end
end