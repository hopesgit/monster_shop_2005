class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/profile"
    else
      flash.now[:notice] = "Incorrect email/password combination."
      render :new
    end
  end
end
