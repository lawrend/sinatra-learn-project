class EventsController < ApplicationController

### CREATE NEW EVENT ###

  get '/events/new' do 
    erb :'/events/create_event'
  end

  post '/events/new' do 
    @event = Event.new(:name => params["name"], :user_id => params["user_id"], :details => params["details"])
    if @event.save
      @event.save
      all_activities = params["activity_ids"]
        if all_activities != nil
          all_activities.each do |activity|
            @event.activities << Activity.find(activity)
          end
        end

        @new_activities = params["new_activity"].delete_if{|e| e==""}
        if !@new_activities.empty?
          @new_activities.each do |activity|
            if Activity.find_by(name: activity) == nil
              @activity = Activity.new(:name => activity)
              @event.activities << @activity 
            else
              if !@event.activities.include?(Activity.find_by(name: activity))
                @event.activities << Activity.find_by(name: activity)
              end
            end
          end
        end
      
      @participant = Participant.new(:event_id => @event.id)
      @participant.save
      all_guests = params["guest_ids"]
        if all_guests != nil
          all_guests.each do |guest|
            @participant.users << User.find(guest)
          end
        end
      redirect "/users/#{@event.user_id}/homepage"
    else
      erb :'events/create_event', locals: {message: "Gotta fill in a name."} 
    end
  end

### LIST ALL EVENTS ###
  get '/events/list' do
  end

### LIST ONE EVENT ###
  get '/events/:id' do 
    @event = Event.find(params[:id])
    erb :'/events/show'
  end

### EDIT ONE EVENT ###

  get '/events/:id/edit' do
    if Helpers.is_logged_in?(session)
      @event = Event.find(params[:id])
      erb :'/events/edit_event'
    else
      redirect "users/logout"
    end
  end

  patch '/events/:id/edit' do
    @user = Helpers.current_user(session)
    @event = Event.find(params[:id])
    @event.update(:name => params["name"], :details => params["details"])
    
    @event.activities = []
    all_activities = params["activity_ids"]
    if all_activities != nil
      all_activities.each do |activity|
        @event.activities << Activity.find(activity)
      end
    end
    
    @new_activities = params["new_activity"].delete_if{|e| e==""}
      if !@new_activities.empty?
        @new_activities.each do |activity|
          if Activity.find_by(name: activity) == nil
            @activity = Activity.new(:name => activity)
            @event.activities << @activity 
          else
            if !@event.activities.include?(Activity.find_by(name: activity))
              @event.activities << Activity.find_by(name: activity)
            end
          end
        end
      end

    all_guests = params["guest_ids"]
    @party = @event.participant
    @party.users = []
    all_guests.each do |guest|
      if !@party.users.include?(User.find(guest))
        @party.users << User.find(guest)
      end
    end
    Helpers.update_activities
    erb :'users/homepage', locals: {message: "That event is updated!"}
  end

### DELETE EVENT ###
  delete '/events/:id/delete' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @event = Event.find(params[:id])
    # DELETE PARTICIPANT OBJECT #
      @participant = @event.participant 
      if @participant != nil
        @participant.delete
      end
      @event.activities = []
    # UPDATE ACTIVITIES #
      Helpers.update_activities
    # DELETE EVENT OBJECT #
      @event.delete
    # RETURN USER TO HOMEPAGE #
      #redirect "/users/#{@user.id}/homepage"
      erb :'users/homepage', locals: {message: "That event is no more."}
    else
      redirect "/"
    end
  end

 
end
