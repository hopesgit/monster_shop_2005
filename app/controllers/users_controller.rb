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
    if @user.authenticate(user_params[:password])
      @user.update(user_params)
    else
      flash[:error] = "Incorrect Password!"
      return redirect_to '/profile/edit'
    end
    if @user.save
      flash[:edited] = "You have successfully updated your profile"
      redirect_to "/profile"
    else
      flash[:error] = "Please select a unique email!"
      redirect_to '/profile/edit'
    end
  end

  def show
    if current_user
      @user = current_user
      flash[:success] = "Logged in as #{current_user.name}."
    else
      render file: "public/404"
    end
  end

  def password_edit
    @user = current_user
  end

  def password_update
    if current_user.update(user_params)
      flash[:message] = 'Password was successfully updated!'
      redirect_to '/profile'
    end
  end

  def orders_index
    @orders = current_user.orders
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
