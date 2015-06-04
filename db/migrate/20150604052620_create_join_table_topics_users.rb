class CreateJoinTableTopicsUsers < ActiveRecord::Migration
  def change
    create_join_table :topics, :users
  end
end
