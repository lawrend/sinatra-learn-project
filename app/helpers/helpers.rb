class Helpers

    def self.current_user(session)
      @user = User.find(session[:user_session_id])
    end

    def self.is_logged_in?(session)
      !!session[:user_session_id]
    end

    def self.update_activities
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
    end
end
