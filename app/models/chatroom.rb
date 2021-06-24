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
    def full_names
        #self.users.map{|user| "#{user.first_name} #{user.last} (#{user.username})"}
        self.users.map{|user| "#{user.first_name} #{user.last_name}"}
    end

    def 
end