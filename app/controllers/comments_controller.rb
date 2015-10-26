class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = Comment.all
  end


  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  #Creates comment to a post and assigning parent_id as post.id
  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.parent_id = @post.id
    @comment.user_id = current_user.id
    @comment.post_id = @post.id
    authorize @comment
    if @comment.save
      flash[:notice] = "Comment was successfully created"
      redirect_to group_path(@group)
    else
      flash[:error] = "Comment was not created"
      redirect_to group_path(@group)
    end

  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @comment
    destroy_children(@comment)
  end

  #destroying the comment branch itself
  def destroy_children(comment)
    if comment == nil or comment == @comment.parent
      redirect_to group_path(params[:group_id]) and return
    else
      if(comment.children.any?)
        comment.children.each do |child|
          destroy_children(child)
        end
      else
        comment_parent = comment.parent
        if comment.destroy
          flash[:notice] = "Comment was successfully deleted"
        end
        destroy_children(comment_parent)
      end
    end
  end

  def new_child
    @parent_comment = Comment.find(params[:comment_id])
    @comment = Comment.new
  end

  #Creates comment child as tree
  def create_child
    parent_comment = Comment.find(params[:id])
    @group = Group.find(params[:group_id])
    @comment = parent_comment.children.new(message: params[:comment]['message'])
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]
    authorize @comment
    if @comment.save
      flash[:notice] = "Comment was successfully created"
      redirect_to group_path(@group)
    else
      flash[:error] = "Comment was not created"
      redirect_to group_path(@group)
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
