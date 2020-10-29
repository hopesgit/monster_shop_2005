class SessionsController < ApplicationController
  def new
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
end
