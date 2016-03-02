class SessionsController < ApplicationController

  before_action :check_log_in

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params['username'], user_params['password'])
    login_user!(@user) if @user
  end

  def destroy
    @user = current_user
    @user.reset_session_token! if @user
    session[:session_token] = nil

    redirect_to cats_url
  end




  private

  def user_params
    params.require(:user)
      .permit(:username, :password)
  end

  def check_log_in
    redirect_to cats_url if current_user && params[:_method] != "DELETE"
  end
end
