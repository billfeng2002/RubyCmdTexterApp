class Chatroom < ActiveRecord::Base
    has_many :userchatrooms
    has_many :users, through: :userchatrooms
    has_many :messages

    # return most popular chatroom 
    def self.most_popular_chatroom
        # chatroom with the highest number of messages
        chatrooms_sorted_by_num_messages = Chatroom.all.sort_by{|chatroom| chatroom.messages.count}
        most_popular_chatroom = chatrooms_sorted_by_num_messages.last
        
        #most_popular_chatroom = Chatroom.all.max{|chatroom1, chatroom2| chatroom1.messages.count <=> chatroom2.messages.count}
    end

    # return names of users in chatroom
    def members
        self.users.map{|user| user.name_and_username}
        #self.users.map{|user| "#{user.first_name} #{user.last_name}"}
    end
    
    # returns an array of users ordered by the number of messages sent
    def user_activity
        self.users.sort_by{|user| user.messages.count}.reverse
    end

    # returns an array of users and the number of messages they've sent
    def top_users
        user_activity.map{|user| "#{user.name_and_username}: #{user.messages.count} messages."}
    end

    # returns an array of messages that contain some word
    def search(substr)
        self.messages.select{|message| message.value.include? substr}
    end

    def last_n_messages(n)
        last_n_messages = self.messages.last(n)
        # format: Bill Feng (billfeng) 6/24/21 11:33 AM - Hello World!
        last_n_messages.map{|message| "#{message.user.name_and_username} - #{message.value}"}
    end
    
    def self.find_chatroom(code:, password:)
        self.find_by(room_code: code, password: password)
    end
    
end