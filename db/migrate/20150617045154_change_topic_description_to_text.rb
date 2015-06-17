class ChangeTopicDescriptionToText < ActiveRecord::Migration
  def up
    change_column :topics, :description, :text
  end

  def down
    execute "update topics set description = LEFT(description, 255);"

    change_column :topics, :description, :string
  end
end
