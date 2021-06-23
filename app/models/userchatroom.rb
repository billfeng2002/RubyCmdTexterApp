#joiner to indicate which users are in which rooms
class UserChatroom < ActiveRecord::Base
    belongs_to :user
    belongs_to :chatroom

end