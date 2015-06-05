class RenameUsersTopicsToTopicsTeachers < ActiveRecord::Migration
  def change
    rename_table :topics_users, :topics_teachers
  end
end
