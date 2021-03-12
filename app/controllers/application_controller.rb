class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_zone_from_session
    
    # error if a user trys to access admin page
    def admin_only
        unless current_user.admin
            redirect_to home_path, notice: 
        "You must be an admin to     perform that function!"
        end
    end

    protected
    #device permitted parameters username and avatar image
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
    end

    private
    
    # time zone for the leaderboard page last updated
    def set_zone_from_session
        Time.zone = ActiveSupport::TimeZone[session[:timezone_offset]] if session[:timezone_offset]
    end
      

end
