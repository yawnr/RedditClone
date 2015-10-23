class CommentsController < ApplicationController

  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = current_user.posts.first.comments.new(comment_params)

    if @comment.save
      redirect_to(post_url(@comment.post))
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end

  end

  def show
    @comment = Comment.find(params[:id])
    redirect_to(post_url(@comment.post))
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
