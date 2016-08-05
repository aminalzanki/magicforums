class PostsController < ApplicationController
  def index
    @posts = Post.all.order(id: :ASC)
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(posts_params)

    if @post.save
      redirect_to posts_path
    else
      redirect_to new_post_path
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])

    if @post.update(posts_params)
      redirect_to posts_path
    else
      redirect_to new_post_path(@post)
    end
  end

def destroy
  @post = Post.find_by(id: params[:id])

  if @post.destroy
    redirect_to posts_path
  else
    redirect_to new_post_path(@post)
  end
end

  private

  def posts_params
    params.require(:post).permit(:title, :body)
  end
end
