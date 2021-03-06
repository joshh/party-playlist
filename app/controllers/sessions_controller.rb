class SessionsController < ApplicationController
  # def create
  #   @user = User.find_or_create_from_auth_hash(auth_hash)
  #   self.current_user = @user
  #   redirect_to '/'
  # end



  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to "/"
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/"
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end