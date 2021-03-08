class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_zone_from_session
    



    
    def admin_only
        unless current_user.admin
            redirect_to home_path, notice: 
        "You must be an admin to     perform that function!"
        end
    end

    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end

    private
    
    def set_zone_from_session
        # set TZ only if stored in session. If not set then the default from config is to be used
        # (it should be set to UTC)
        Time.zone = ActiveSupport::TimeZone[session[:timezone_offset]] if session[:timezone_offset]
    end
      

end
