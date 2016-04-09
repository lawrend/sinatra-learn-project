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
      erb :'failure'
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
    if User.find_by(username: params["username"]) != nil
      erb :'/users/create_user', locals: {message: "Sorry, but that username is already taken."}
    else
      @user = User.create(username: params["username"], email: params["email"], password: params["password"])
      if @user.save
        @user.save
        session[:user_session_id] = @user.id
        redirect "/users/#{@user.id}/homepage"
      else
        erb :'failure'
      end
    end
  end

  ### HOMEPAGE ###
  get '/users/:id/homepage' do
    @user = User.find(params[:id])
    erb :'/users/homepage'
  end

  ### LIST A USER'S EVENTS ###
  get '/users/:id/events' do 
    @user = User.find(params[:id])
    erb :'/users/events'
  end

  ### LIST EVENTS A USER IS ATTENDING ###
  get '/users/:id/participating' do
    if Helpers.is_logged_in?(session) 
      @user = Helpers.current_user(session)
      erb :'/users/participating'
    else
      redirect "/users/logout"
    end
  end

  
  ### LOGOUT ###
  get '/users/logout' do 
    session.clear
    redirect "/"
  end

end
