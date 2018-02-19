class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_token

  def check_token
    if current_user

    else
    end
  end

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user


end
