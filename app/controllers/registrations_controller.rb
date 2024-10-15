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
#       else
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
#     end
#   end

def confirm_registration
  if params[:commit] == "register"
    @user = User.new(user_params)
    # @user.profile = ""

    if @user.valid?
      if params[:user][:profile].present?
        # uploaded_file = params[:user][:profile]
        # filename = "#{SecureRandom.uuid}_#{uploaded_file.original_filename}"
        # file_path = Rails.root.join('public', 'uploads', filename)
        # File.open(file_path, 'wb') do |f|
        #   f.write(uploaded_file.read)
        # end
      # end
      # @user.profile = file_path
      @user.save
      render :confirmation
    else
      render :new
    end
  end
end

def create
    @user = User.new(user_params)
    if @user.save
      render :new
    else
      render :confirmation
    end
end

def authenticate_user!
  if !current_user
    flash[:notice] = 'You need to sign in or sign up before continuing.'
    redirect_to new_user_session_path
  end
end
end


end
