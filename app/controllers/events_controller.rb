class EventsController < ApplicationController

### CREATE NEW EVENT ###

  get '/events/new' do 
    erb :'/events/create_event'
  end

  post '/events/new' do 
    @event = Event.new(:name => params["name"], :user_id => params["user_id"], :details => params["details"])
    @event.save
    all_activities = params["activity_ids"]
      if all_activities != nil
        all_activities.each do |activity|
          @event.activities << Activity.find(activity)
        end
      end
      if !params["new_activity"].empty?
        @existing_activity_names = []
          Activity.all.each do |activity|
            @existing_activity_names << activity.name 
          end
        if @existing_activity_names != params["new_activity"]
          @activity = Activity.new(:name => params["new_activity"])
          @activity.save
          @event.activities << @activity
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
    @event = Event.find(params[:id])
    erb :'/events/edit_event'
  end

  patch '/events/:id/edit' do
    @event = Event.find(params[:id])
    @event.update(:name => params["name"], :details => params["details"])
    @event.activities = []
    all_activities = params["activity_ids"]
      if all_activities != nil
        all_activities.each do |activity|
          @event.activities << Activity.find(activity)
        end
      end
    if !params["new_activity"].empty?
      Activity.all.each do |activity|
        if activity.name != params["new_activity"]
          @activity = Activity.new(:name => params["new_activity"])
          @activity.save
          @event.activities << @activity
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
    redirect "/users/#{@event.user_id}/homepage"
  end

### DELETE EVENT ###
  delete '/events/:id/delete' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @event = Event.find(params[:id])
      @participant = @event.participant 
      if @participant != nil
        @participant.delete
      end
      @event.activities = []
      ### UPDATE ACTIVITIES ###
      @current_activities = []
      Event.all.each do |event|
        event.activities.each do |activity|
          @current_activities << activity
        end
      end
      @current_activities.uniq!
      Activity.all.each do |activity|
        if !@current_activities.include?(activity)
          activity.delete 
        end
      end
      @event.delete
     redirect "/users/#{@user.id}/homepage"
    end
  end

 
end
