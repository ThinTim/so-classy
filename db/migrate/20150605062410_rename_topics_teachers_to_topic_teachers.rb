class RenameTopicsTeachersToTopicTeachers < ActiveRecord::Migration
  def change
    rename_table :topics_teachers, :topic_teachers
  end
end
