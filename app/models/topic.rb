class Topic < ActiveRecord::Base
  has_and_belongs_to_many :teachers, class_name: 'User', join_table: 'topics_teachers'
  has_and_belongs_to_many :students, class_name: 'User', join_table: 'topics_students'

  validates_uniqueness_of :name
end
