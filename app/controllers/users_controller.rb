class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new(user_params)
    if params[:password] != params[:confirm_password]
      flash.now[:error] = "Passwords must match"
      render :new
    elsif !User.where(email_address: @user.email_address).empty?
      flash.now[:error] = "Please select a unique email!"
      render :new
    elsif @user.save
      flash[:success] = "Welcome #{@user.name}"
      session[:user_id] = @user.id
      redirect_to '/profile'
    else
      flash.now[:error] = "Please fill in all fields!"
      render :new
    end
  end

  def show
    flash[:success] = "Logged in as #{current_user.name}."
  end

  private
  def user_params
    params.permit(:name, :street_address, :city, :state,
       :zip, :email_address, :password)
  end
end
