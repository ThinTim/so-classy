class AddTimestampsToTeacherAndStudentRelationships < ActiveRecord::Migration
  def up
    add_timestamps :topic_teachers, null: true
    add_timestamps :topic_students, null: true

    execute "update topic_students set created_at = current_timestamp;"
    execute "update topic_students set updated_at = current_timestamp;"

    execute "update topic_teachers set created_at = current_timestamp;"
    execute "update topic_teachers set updated_at = current_timestamp;"


    change_column_null :topic_teachers, :created_at, false
    change_column_null :topic_teachers, :updated_at, false

    change_column_null :topic_students, :created_at, false
    change_column_null :topic_students, :updated_at, false
  end

  def down
    execute "alter table topic_students drop column created_at;"
    execute "alter table topic_students drop column updated_at;"

    execute "alter table topic_teachers drop column created_at;"
    execute "alter table topic_teachers drop column updated_at;"
  end
end
