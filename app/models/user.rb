class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable

    attr_accessor :login

    def self.find_for_database_authentication(warden_conditions)
        conditions = warden_conditions.dup
        if login = conditions.delete(:login)
            where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
        else
            where(conditions).first
        end
    end
end
