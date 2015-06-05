class RenameTopicsStudentssToTopicStudents < ActiveRecord::Migration
  def change
    rename_table :topics_students, :topic_students
  end
end
