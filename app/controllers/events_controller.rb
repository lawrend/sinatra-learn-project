class EventsController < ApplicationController

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
        @activity = Activity.new(:name => params["new_activity"])
        if !Activity.all.include? @activity.name
          @activity.save
        end
        @event.activities << @activity 
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

  get '/events/list' do
  end

  get '/events/:id' do 
    @event = Event.find(params[:id])
    erb :'/events/show'
  end

  get '/events/:id/edit' do
    @event = Event.find(params[:id])
    erb :'/events/edit_event'
  end

  post '/events/:id/edit' do
  end
 
end
