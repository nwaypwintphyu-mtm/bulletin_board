require 'csv'
class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token #csrf token
  before_action :authenticate_user!
  # GET /posts or /posts.json
  def index
    @posts = Post.all
        if current_user.utype == "1"
          @posts = Post.includes(:user).where(create_user_id: current_user.id).page(params[:page]).per(4).order("id DESC")
         
        else
          @posts = Post.includes(:user).page(params[:page]).per(4).order("id DESC")
        end

        # for search with keyword
        if params[:keyword].present?
          @posts = @posts.where("title LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
        end
          @posts = @posts.page(params[:page]).per(4).order("id DESC")
  end


  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end
 
  # for confirm
  def confirm
    @post = Post.new(params[:post])
    render :confirm
  end

  def upload_csv
    csv_file = params['csv_file']
    if csv_file.present?
      detected_encoding = CharDet.detect(File.read(csv_file.path))[:encoding]
      csv_content = File.read(csv_file.path).encode('UTF-8', detected_encoding, invalid: :replace, undef: :replace, replace: '')
  
      # file type validation
      if !csv_file.content_type.match?(/text\/csv/)
        @error = 'Please choose a CSV file'
        return render :upload_post
      end
  
      # parse CSV file
      csv = CSV.parse(csv_content, headers: true)
  
      # check number of columns in the first row
      if csv.first.size != 3
        @error = 'Post upload csv must have 3 columns'
        return render :upload_post
      else
        # process CSV data
        csv.each do |row|
          @post = Post.new
          @post.title = row['Title']
          @post.description = row['Description']
          @post.status = row['Status']
          @post.create_user_id = current_user.id
          @post.updated_user_id = current_user.id
          @post.created_at = Time.current
          @post.updated_at = Time.current
          begin
            @post.save!
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error "Error saving post: #{e.message}"
            flash[:error] = "Error saving post: #{e.message}"
            render :index and return
          end
        end
        flash[:notice] = 'CSV file uploaded successfully!'
        redirect_to root_path
      end
    else
      @error = "Please choose a file"
      return render :upload_post
    end
  end

  def download_csv
    request.format = :csv
    @posts = Post.all
    csv_string = CSV.generate do |csv|
      csv << ['id', 'title', 'description', 'status', 'create_user_id', 'updated_user_id','deleted_user_id','deleted_at','created_at','updated_at']
      @posts.each do |post|
        csv << [
          post.id,
          post.title,
          post.description,
          post.status,
          post.create_user_id,
          post.updated_user_id,
          post.deleted_user_id,
          post.deleted_at,
          post.created_at.strftime('%Y/%m/%d'),
          post.updated_at.strftime('%Y/%m/%d')
        ]
      end
    end

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"posts_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv\""
        headers['Content-Type'] = 'text/csv'
        send_data csv_string, type: 'text/csv', disposition: 'attachment'
      end
    end

  end


  def create
    if params[:commit] == "create"
      @post = Post.new(post_params)
      if @post.valid?
        session[:post] = @post
        render :new_post_confirm
      else
        render :new
      end
    elsif params[:commit] == "clear"
      # session[:post] = nil
      @post = Post.new
      render :new
    elsif params[:commit] == "cancel"
      # session[:post] = nil
      redirect_to posts_path
    elsif params[:commit] == "confirm"
      post_attributes = session[:post]
      @post = Post.new(post_attributes)
      if @post.save
        session[:post] = nil
        redirect_to posts_path, notice: "Post was successfully created."
      else
      end
    end

 
    
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update_post
   
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update 
    @post = Post.find(params[:id])
      # for edit button 
      if params[:commit] == "edit"
        @post.assign_attributes(post_params)
        if post_params[:title].empty?
          @post.errors.add(:title, "Titel can't be blank")
        end
        if @post.valid?
          render :edit_post_confirm
        else
          render :edit
        end
      end 
      if params[:commit] == "clear"
        @post.assign_attributes({ title: "", description: "" })
        render :edit
      end
      if params[:commit] == "confirm"
        if @post.update(post_params)
          redirect_to posts_path, notice: "Post was successfully updated."
        end
      end
      if params[:commit] == "cancle"
          redirect_to edit_post_path
      end
   end
  

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :status, :create_user_id, :updated_user_id)
  end


end
