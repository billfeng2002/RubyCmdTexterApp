class AddTimestampsToMessages < ActiveRecord::Migration[6.1]
  def change
    # thanks to spickermann from stackoverflow for providing this answer (https://stackoverflow.com/questions/46520907/add-timestamps-to-existing-table-in-db-rails-5)
    
    # add new column but allow null values
    add_timestamps :messages, null: true 

    # backfill existing records with created_at and updated_at
    # values that make clear that the records are faked
    long_ago = DateTime.new(2000, 1, 1)
    Message.update_all(created_at: long_ago, updated_at: long_ago)

    # change to not null constraints
    change_column_null :messages, :created_at, false
    change_column_null :messages, :updated_at, false
  end
end
