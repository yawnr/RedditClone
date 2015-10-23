class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:name],
      params[:user][:password]
    )

    if user
      login!(user)
    else
      flash[:errors] = "Invalid Login Credentials"
      render :new
    end

  end

  def destroy
    logout!
  end

end
