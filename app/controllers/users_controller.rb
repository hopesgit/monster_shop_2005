class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.create!(user_params)
    flash[:success] = "Welcome #{@user.name}"
    session[:user_id] = @user.id
    redirect_to '/profile'
  end

  def show
    @user = User.find(session[:user_id])
    if session[:user_id]
      flash[:success] = "Logged in as #{@user.name}."
    end 
  end

  private
  def user_params
    params.permit(:name, :street_address, :city, :state,
       :zip, :email_address, :password)
  end
end
