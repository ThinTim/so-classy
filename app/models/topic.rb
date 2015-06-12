class Topic < ActiveRecord::Base
  has_many :topic_teachers
  has_many :teachers, through: :topic_teachers, source: :user

  has_many :topic_students
  has_many :students, through: :topic_students, source: :user

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates_presence_of :name
  validates_uniqueness_of :name

  def popularity
    (self.teachers + self.students).uniq.size
  end
end
