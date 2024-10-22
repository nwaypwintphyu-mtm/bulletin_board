class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token 
  before_action :reset_session


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :utype, :phone, :dob, :address, :profile)
  end

  def new
    @user = User.new
  end



  # CORRECT
#   def create
#     # make for new user confirmation
#     if params[:commit] == "register"
#       @user = User.new(user_params)
#       if @user.valid?
#         uploaded_file = params[:user][:profile]
#         file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)
#         File.open(file_path, 'wb') do |f|
#           f.write(uploaded_file.read)
#         end
#         session[:user] = @user
#         render :confirmation, locals: { user: @user,file_path: file_path }
#         render :new 
#       end
#     elsif params[:commit] == "clear"
#       @user = User.new
#       render :new
#     elsif params[:commit] == "cancel"
#       redirect_to new_user_session_path

#     elsif params[:commit] == "confirm"
#       @user = User.new(user_attributes)
#         if @user.save
#           redirect_to root_url, notice: "User  was successfully created."
#         else
#           render :confirmation
#         end
#       end
# end


# correct code
def create
  if params[:commit] == 'register'
    @user = User.new(user_params)
    if @user.save
      uploaded_file = params[:user][:profile]
      if uploaded_file.present?
        @user.update(profile: uploaded_file)
        flash[:notice] = "Image uploaded successfully."
      else
        flash.now[:alert] = "Please upload a profile image."
      end
      redirect_to root_url
    else
      flash.now[:alert] = "Failed to save user information."
      render :new 
    end
  end
  if params[:commit] == 'clear'
    @user = User.new
    render :new
  end
end


private

def upload_profile_image
  uploaded_file = params[:user][:profile]
  return unless uploaded_file.present?

  file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)
  File.open(file_path, 'wb') do |f|
    f.write(uploaded_file.read)
  end
rescue StandardError => e
  Rails.logger.error("Error uploading profile image: #{e.message}")
  @user.errors.add(:profile, "upload failed")
end




def confirm_registration
  if params[:commit] == 'confirm'
      redirect_to new_user_session_path
    else
      render :new
    end
  end
end

def authenticate_user!
  if !current_user
    flash[:notice] = 'You need to sign in or sign up before continuing.'
    redirect_to new_user_session_path
  end
end
