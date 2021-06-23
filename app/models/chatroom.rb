class Chatroom < ActiveRecord::Base
    has_many :userchatrooms
    has_many :users, through: :userchatrooms
    has_many :messages
end