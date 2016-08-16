class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order("created_at ASC")
    @comment = Comment.new
  end

  # def new
  #   @post = Post.find_by(id: params[:post_id])
  #   @topic = @post.topic
  #   @comment = Comment.new
  #   authorize @comment
  # end

  def create
  @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
  @new_comment = Comment.new
  @post = Post.find_by(id: params[:post_id])

  if @comment.save
    # CommentBroadcastJob.set(wait: 0.1.seconds).perform_later("create", @comment)
    CommentBroadcastJob.perform_later("create", @comment)
    flash.now[:success] = "Comment created"
  else
    flash.now[:danger] = @comment.errors.full_messages
  end
end

  # def create
  #   @post = Post.find_by(id: params[:post_id])
  #   @topic = @post.topic
  #   @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
  #
  #   if @comment.save
  #     redirect_to topic_post_comments_path(@topic, @post)
  #   else
  #     redirect_to new_topic_post_comment_path(@topic, @post)
  #   end
  # end

  def edit
    # @post = Post.find_by(id: params[:post_id])
    # @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
  end

  def update
    # @post = Post.find_by(id: params[:post_id])
    # @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.update(comment_params)
      CommentBroadcastJob.set(wait: 0.1.seconds).perform_later("update", @comment)
      flash.now[:success] = "Comment updated"
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
    # @post = @comment.post
    # @topic = @post.

    if @comment.destroy
      flash.now[:success] = "Comment deleted"
      CommentBroadcastJob.perform_now("destroy", @comment)
    else
      flash.now[:danger] = "Error deleting comment"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image)
  end
end
