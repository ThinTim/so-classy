class Topic < ActiveRecord::Base
  has_many :topic_teachers
  has_many :teachers, through: :topic_teachers, source: :user

  has_and_belongs_to_many :students, class_name: 'User', join_table: 'topics_students'

  validates_uniqueness_of :name
end
