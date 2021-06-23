#joiner to indicate which users are in which rooms
class Userchatroom < ActiveRecord::Base
    belongs_to :user
    belongs_to :chatroom

end