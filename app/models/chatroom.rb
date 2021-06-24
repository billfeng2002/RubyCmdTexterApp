class Chatroom < ActiveRecord::Base
    has_many :userchatrooms
    has_many :users, through: :userchatrooms
    has_many :messages

    def self.chatroom_taken(code)
        return !!(Chatroom.find_by(room_code: code))
    end
end