class CreateJoinTableTopicsStudents < ActiveRecord::Migration
  def change
    create_join_table :topics, :users, { table_name: :topics_students }
  end
end
