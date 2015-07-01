class SessionsController < ApplicationController
  def show
    redirect_to root_path unless session['auth']
    @auth = session[:user_id]
  end

  
  def create
    # Fetches the OAuth response info
    @auth = request.env['omniauth.auth']
    if User.where(:fb_id => @auth["uid"]).first
      @user = User.where(:fb_id => @auth["uid"]).first
    else
    @user = User.create(
      :first_name => @auth["info"]["name"],
      :photo => @auth["info"]["image"],
      :fb_id => @auth["uid"],
      )
    end
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
