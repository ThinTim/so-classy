class CombineDuplicateEmails < ActiveRecord::Migration
  def change
    canonicalise_emails = 'UPDATE USERS SET email = TRIM(LOWER(email));'

    create_mapping_table = <<-QUERY
      CREATE TEMPORARY TABLE user_mappings AS
      SELECT currents.id as current_id, canonicals.id as new_id
      FROM USERS currents
      INNER JOIN
      (
        SELECT a.email, a.id
        FROM USERS a
        WHERE a.id = (
          SELECT MIN(b.id)
          FROM USERS b
          WHERE b.email = a.email
        )
      ) canonicals
      ON currents.email = canonicals.email
      WHERE currents.id != canonicals.id;
    QUERY

    update_topics = <<-QUERY
      UPDATE topics
      SET owner_id = user_mappings.new_id
      FROM user_mappings
      WHERE topics.owner_id = user_mappings.current_id;
    QUERY

    update_comments = <<-QUERY
      UPDATE comments
      SET author_id = user_mappings.new_id
      FROM user_mappings
      WHERE comments.author_id = user_mappings.current_id;
    QUERY

    update_topic_teachers = <<-QUERY
      UPDATE topic_teachers
      SET user_id = user_mappings.new_id
      FROM user_mappings
      WHERE topic_teachers.user_id = user_mappings.current_id;
    QUERY

    update_topic_students = <<-QUERY
      UPDATE topic_students
      SET user_id = user_mappings.new_id
      FROM user_mappings
      WHERE topic_students.user_id = user_mappings.current_id;
    QUERY

    delete_old_users = <<-QUERY
      DELETE FROM USERS
      WHERE id IN (
        SELECT current_id
        FROM user_mappings
      );
    QUERY

    drop_mapping_table = 'DROP TABLE user_mappings;'

    execute canonicalise_emails
    execute create_mapping_table
    execute update_topics
    execute update_comments
    execute update_topic_teachers
    execute update_topic_students
    execute delete_old_users
    execute drop_mapping_table
  end
end
