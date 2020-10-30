class SessionsController < ApplicationController
  def new
    if current_admin?
      flash[:error] = 'You are already logged in!'
      redirect_to '/admin'
    elsif current_merchant?
      flash[:error] = 'You are already logged in!'
      redirect_to '/merchant'
    elsif current_user
      flash[:error] = 'You are already logged in!'
      redirect_to '/profile'
    end
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user.authenticate(params[:password]) && user.default?
      session[:user_id] = user.id
      redirect_to "/profile"
    elsif user.authenticate(params[:password]) && user.merchant?
      session[:user_id] = user.id
      redirect_to '/merchant'
    elsif user.authenticate(params[:password]) && user.admin?
      session[:user_id] = user.id
      redirect_to "/admin"
    else
      flash.now[:notice] = "Incorrect email/password combination."
      render :new
    end
  end

  def destroy
    reset_session
    flash[:notice] = 'You are logged out!'
    redirect_to '/'
  end
end
