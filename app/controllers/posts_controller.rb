class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  #Post in all groups of which current_user is a member
  def index
    group_ids = current_user.groups.select(:id)
    group_id = Group.find_by(name: "public").id
    @posts = Post.all.where("group_id != ? AND group_id IN (?)", group_id , group_ids).page(params[:page]).per(8)
  end

  def show
  end

  def new
  end

  def edit
  end

  # Create a post in group and save user who posted it and in which group.
  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.build(post_params)
    @post.user_id = current_user.id
    @post.group_id = @group.id
    authorize @post
    # @post.post_time = DateTime.now.utc.to_i - @post.created_at.to_i
    if @post.save
      redirect_to group_path(@group), notice: "Post was successfully created"
    else
      flash[:error] = "Post not created " + @post.errors.messages[:message].to_s
      redirect_to group_path(@group)
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @post
    if @post.destroy
      flash[:notice] = "Post was successfully deleted"
    else
      flash[:error] = "Post was not deleted"
    end
    redirect_to group_path(params[:group_id]) and return
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:message)
  end


end
