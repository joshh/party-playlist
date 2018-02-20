class UsersController < ApplicationController

  before_action :check_login

  def check_login
    redirect_to '/' if !current_user
  end


  def play
    current_user.play
    render plain: 'OK'
  end

  def pause
    current_user.pause
    render plain: 'OK'
  end

  def prev
    current_user.prev
    render plain: 'OK'
  end

  def next
    current_user.next
    render plain: 'OK'
  end

end