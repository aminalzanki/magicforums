class PostsController < ApplicationController
respond_to :js
before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]
  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @posts = @topic.posts.order("created_at ASC")
    @post = Post.new
  end

  # def new
  #   @topic = Topic.find_by(id: params[:topic_id])
  #   @post = Post.new
  # end

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @post = current_user.posts.build(post_params.merge(topic_id: params[:topic_id]))

    if @post.save
      redirect_to topic_posts_path(@topic)
    else
      redirect_to new_topic_post_path(@topic)
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    @topic = @post.topic
    authorize @post
  end

  def update
    @post = Post.find_by(id: params[:id])
    @topic = @post.topic
    authorize @post

    if @post.update(post_params)
      # redirect_to topic_posts_path(@topic)
      flash.now[:success] = "Post updated"
    else
      # redirect_to edit_topic_post_path(@topic, @post)
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @topic = @post.topic

    if @post.destroy
      redirect_to topic_posts_path(@topic)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
