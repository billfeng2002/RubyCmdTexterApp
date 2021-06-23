class User < ActiveRecord::Base
    has_many :userchatrooms
    has_many :chatrooms, through: :userchatrooms
    has_many :messages
    
end