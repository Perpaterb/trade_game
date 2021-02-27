class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    
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


end
