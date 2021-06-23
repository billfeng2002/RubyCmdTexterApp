class User < ActiveRecord::Base
    has_many :chatrooms
    has_many :messages
end