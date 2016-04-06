class UsersController < ApplicationController

  
  ### LOGIN ###
  get '/users/login' do
    if Helpers.is_logged_in?(session)
      current_user = Helpers.current_user(session)
      redirect "/users/#{current_user.id}/homepage"
    else
      erb :'/users/login'
    end
  end

  post '/users/login' do 
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_session_id] = @user.id
      redirect "/users/#{@user.id}/homepage"
    else
      redirect "users/login"
    end
  end

  ### SIGNUP ###
  get '/users/new' do 
    if Helpers.is_logged_in?(session)
      current_user = Helpers.current_user(session)
      redirect "/users/#{current_user.id}/homepage"
    else
      erb :'/users/create_user'
    end
  end

  post '/users/new' do 
    @user = User.new(username: params["username"], email: params["email"], password: params["password"])
    #if !@user.username.empty? && !@user.email.empty? && @user.password != nil
      @user.save
      session[:user_session_id] = @user.id
      redirect "/users/#{@user.id}/homepage"
    #else
     # redirect "/users/new"
    #end
  end

  ### HOMEPAGE ###

  get '/users/:id/homepage' do
    @user = User.find(params[:id])
    erb :'/users/homepage'
  end
  
  ### LOGOUT ###
  get '/users/logout' do 
    session.clear
    redirect "/"
  end

end
