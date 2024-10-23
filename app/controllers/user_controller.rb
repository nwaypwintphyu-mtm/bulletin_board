
class UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :utype, :phone, :dob, :address, :profile)
  end

  def show
    render :new
  end
  
  def index
    if(current_user.utype == "0")
      @Users = User.page(params[:page]).per(5).order("id DESC")
      # if params[:name_keyword].present? || params[:email_keyword].present? || params[:from_keyword].present? || params[:to_keyword].present?
      #   # @Users = @Users.where("name LIKE ? OR email LIKE ?", "%#{params[:name_keyword]}%", "%#{params[:email_keyword]}%")
      #   # if params[:from_keyword].present? && params[:to_keyword].present?
      #   #   @Users = @Users.where("created_at BETWEEN ? AND ?", params[:from_keyword], params[:to_keyword])
      #   # end
      # end
      if params[:name_keyword].present?
        @Users = @Users.where("LOWER(name) LIKE ?", "%#{params[:name_keyword].downcase}%")
      end
      if params[:email_keyword].present?
        @Users = @Users.where("LOWER(email) LIKE ?", "%#{params[:email_keyword].downcase}%")
      end
      if params[:from_keyword].present? && params[:to_keyword].present?
        @Users = @Users.where("created_at BETWEEN ? AND ?", params[:from_keyword], params[:to_keyword])
      end
    else
      flash[:notice] = 'You do not have permission to access this page.'
      redirect_to root_path
    end
  end

  # for confirm
  def confirm
    @user = User.new(params[:post])
    render :confirm
  end

  # for delete
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to user_index_path, notice: "User  deleted successfully"
  end

  def edit
    @user = User.find(params[:id])
    render 'edit_profile'
  end

  def update
    @user = User.find(params[:id])
    if params[:commit] == "edit"
    has_errors = false

    if user_params["name"].empty?
      @user.errors.add(:name_error,"Name can't be blank.")
      has_errors = true
    end

    if user_params["email"].empty?
      @user.errors.add(:email_error, "Email can't be blank.")
      has_errors = true
    else
    unless valid_email_format?(user_params["email"])
      @user.errors.add(:email_error, "Email format is invalid.")
      has_errors = true
    end
    end
    if has_errors
      render :edit_profile and return
    end
      # for un choose image
      if user_params["profile"] == nil
        profile = @user.profile
      else
        profile = user_params["profile"]
      end

      # update process
      if  @user.update_attribute(:name, user_params["name"]) && 
          @user.update_attribute(:email, user_params["email"]) &&
          @user.update_attribute(:utype, user_params["utype"]) &&
          @user.update_attribute(:phone, user_params["phone"]) &&
          @user.update_attribute(:dob, user_params["dob"]) &&
          @user.update_attribute(:address, user_params["address"]) &&
          @user.update_attribute(:profile, profile) 

          # success condition
          redirect_to user_profile_path, notice: "User was successfully updated."
      else
          #fail condition
          render :edit_profile
      end

    elsif params[:commit] == "clear"
      # clear condition
      @user = User.new
      render :edit_profile

    end
  end

  def profile

  end

  def valid_email_format?(email)
    regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    regex.match?(email)
  end
end


