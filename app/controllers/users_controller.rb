class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new(user_params)
    if !User.where(email_address: @user.email_address).empty?
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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(update_params)
    @user.save
    @user = current_user
      flash[:success] = "You have successfully updated your profile"
      redirect_to "/profile"
  end



  def show
    if current_user
      @user = current_user
      flash[:success] = "Logged in as #{current_user.name}."
    else
      render file: "public/404"
    end
  end

  private
  def user_params
    params.permit(:name, :street_address, :city, :state,
       :zip, :email_address, :password, :password_confirmation)
  end

  def update_params
    params.permit(:name, :street_address, :city, :state,
       :zip, :email_address)
  end
end
