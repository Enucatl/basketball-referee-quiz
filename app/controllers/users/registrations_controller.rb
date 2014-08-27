class Users::RegistrationsController < Devise::RegistrationsController
    def build_resource(hash=nil)
        super
        self.resource.rating = 1500
        self.resource.deviation = 350
        self.resource.volatility = 0.06
        self.resource
    end
end 
