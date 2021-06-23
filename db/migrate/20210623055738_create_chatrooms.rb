class CreateChatrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chatrooms do
      |t|
      t.string :name
      t.string :owner_id
      t.string :room_code
      t.string :password
    end
  end
end
