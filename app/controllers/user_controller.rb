
class UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  
def index
  if(current_user.utype == "0")
    @Users = User.page(params[:page]).per(7)
    if params[:name_keyword].present? || params[:email_keyword].present? || params[:from_keyword].present? || params[:to_keyword].present?
      # some errror
      @Users = @Users.where("name LIKE ? OR email LIKE ?", "%#{params[:name_keyword]}%", "%#{params[:email_keyword]}%")
      if params[:from_keyword].present? && params[:to_keyword].present?
        @Users = @Users.where("created_at BETWEEN ? AND ?", params[:from_keyword], params[:to_keyword])
      end
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

  def authenticate_user!
    if !current_user
      flash[:notice] = 'You need to sign in or sign up before continuing.'
      redirect_to new_user_session_path
    end
  end

end




