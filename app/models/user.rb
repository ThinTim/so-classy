class User < ActiveRecord::Base
  # has_and_belongs_to_many :teaching_topics, class_name: 'Topic', join_table: 'topics_teachers'
  # has_and_belongs_to_many :learning_topics, class_name: 'Topic', join_table: 'learning_topics'


  validates_uniqueness_of :email
end
