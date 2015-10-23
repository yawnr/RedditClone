class SubsController < ApplicationController
before_action :is_moderator?, only: [:edit, :destroy]

  def new
    @sub = Sub.new
    render :new
  end

  def index
    @subs = Sub.all
    render :index
  end

  def create
    @sub = Sub.new(sub_params)
    if @sub.save
      redirect_to subs_url
    else
      flash[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def destroy
    @sub = Sub.find(params[:id])
    @sub.destroy
    redirect_to subs_url
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def is_moderator?
    sub = Sub.find(params[:id])
    if !(current_user && (sub.moderator_id == current_user.id))
      redirect_to subs_url
    else
      true
    end
  end



end
