require_relative '../config/environment'
#delete all the stored data
User.destroy_all
Userchatroom.destroy_all
Chatroom.destroy_all
Message.destroy_all

Faker::Lorem.unique.clear #reset faker unique name generation when reseeding

#create users
50.times do
    random_name=Faker::Name.name.split(" ")
    User.create(first_name: random_name[0], last_name: random_name[1], username: Faker::Lorem.unique.word, password: Faker::Config.random.seed)
end

#create chatrooms
10.times do
    Chatroom.create(name: Faker::Mountain.name, owner_id: User.ids.sample, room_code: Faker::Lorem.unique.word, password: Faker::Config.random.seed)
end

#create messages
500.times do
    Message.create(user_id: User.ids.sample, chatroom_id: Chatroom.ids.sample, value: Faker::Quote.famous_last_words)
end

#link users to chatrooms
Chatroom.ids.each do
    |chat_room_id|
    User.ids.sample(15).each do
        |user_id|
        Userchatroom.create(user_id: user_id, chatroom_id: chat_room_id)
    end
end


