class PostsController < ApplicationController

  before_action :is_author?, only: [:edit, :destroy]

    def new
      @post = Post.new
      render :new
    end

    def create
      @post = Post.new(post_params.merge({:author_id => current_user.id}))
      @post = current_user.posts.new(post_params)
      if @post.save
        redirect_to post_url(@post)
      else
        fail
        flash.now[:errors] = @post.errors.full_messages
        render :new
      end
    end

    def destroy
      @post = Post.find(params[:id])
      sub = @post.sub
      @post.destroy
      redirect_to sub_url(sub)
    end

    def edit
      @post = Post.find(params[:id])
      render :edit
    end

    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to post_url(@post)
      else
        flash[:errors] = @post.errors.full_messages
        render :edit
      end
    end

    def show
      @post = Post.find(params[:id])
      render :show
    end

    private

    def post_params
      params.require(:post).permit(:title, :url, :content, sub_ids:[])
    end

    def is_author?
      post = Post.find(params[:id])
      if !(current_user && (post.author_id == current_user.id))
        flash[:errors] = "You can't edit a post you did not author."
        redirect_to sub_url(post.sub)
      else
        true
      end
    end

end
