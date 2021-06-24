class User < ActiveRecord::Base
    has_many :userchatrooms
    has_many :chatrooms, through: :userchatrooms
    has_many :messages
    
    #checks if user with given username exists
    def self.username_taken(username)
        return !!(User.find_by(username: username))
    end

    
    def self.check_login(username:, password:)
        User.find_by(username: username, password: password)
    end

end