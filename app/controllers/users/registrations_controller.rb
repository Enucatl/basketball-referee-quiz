class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    def build_resource(hash=nil)
        super
        self.resource.rating = 1500
        self.resource.deviation = 350
        self.resource.volatility = 0.06
        self.resource.break_on_success = false
        self.resource.break_on_failure = true
        self.resource
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
        devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
        devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end
end 
