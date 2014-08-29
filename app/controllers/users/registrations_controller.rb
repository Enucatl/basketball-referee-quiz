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
        devise_parameter_sanitizer.for(:sign_up) do |u|
            u.permit(:username, :email, :password, :password_confirmation, :remember_me)
        end
        devise_parameter_sanitizer.for(:sign_in) do |u|
            u.permit(:login, :username, :email, :password, :remember_me)
        end
        devise_parameter_sanitizer.for(:account_update) do |u|
            u.permit(:username, :email, :password, :password_confirmation, :current_password,
                     :break_on_success, :break_on_failure)
        end
    end

    def update
        @user = User.find(current_user.id)

        successfully_updated = if needs_password?(@user, params)
                                   @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
                               else
                                   # remove the virtual current_password attribute
                                   # update_without_password doesn't know how to ignore it
                                   params[:user].delete(:current_password)
                                   @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
                               end

        if successfully_updated
            set_flash_message :notice, :updated
            # Sign in the user bypassing validation in case their password changed
            sign_in @user, :bypass => true
            redirect_to after_update_path_for(@user)
        else
            render "edit"
        end
    end

    private

    # check if we need password to update user data
    # ie if password or email was changed
    # extend this as needed
    def needs_password?(user, params)
        params[:user][:username].present? || 
            params[:user][:email].present? || 
            params[:user][:password].present? ||
            params[:user][:password_confirmation].present?
    end
end 
