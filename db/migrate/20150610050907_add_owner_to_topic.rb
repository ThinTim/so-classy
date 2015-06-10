class AddOwnerToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :owner_id, :integer
  end
end
