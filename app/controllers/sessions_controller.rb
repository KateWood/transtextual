class SessionsController < ApplicationController
  def show
    redirect_to root_path unless session['auth']
    @auth = session['auth']
  end

  
  def create
    # Fetches the OAuth response info
    @auth = request.env['omniauth.auth']
    if User.where(:spotify_id => @auth["info"]["id"]).first
      @user = User.where(:spotify_id => @auth["info"]["id"]).first
    else
      if @auth["info"]["images"][0]["url"] == ""
        @user = User.create(
        :display_name => @auth["info"]["display_name"],
        :token => @auth["credentials"]["token"],
        :refresh_token => @auth["credentials"]["refresh_token"],
        :image_url => 'muziqala_logo.jpq',
        :spotify_id => @auth["info"]["id"],
        :user_uri => @auth["info"]["uri"]
        )
      else
      @user = User.create(
        :display_name => @auth["info"]["display_name"],
        :token => @auth["credentials"]["token"],
        :refresh_token => @auth["credentials"]["refresh_token"],
        :image_url => @auth["info"]["images"][0]["url"],
        :spotify_id => @auth["info"]["id"],
        :user_uri => @auth["info"]["uri"]
        )
      end
    end
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end


  def destroy
    session['auth'] = nil
    redirect_to root_path
  end
end
