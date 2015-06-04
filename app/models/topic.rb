class Topic < ActiveRecord::Base
  has_and_belongs_to_many :teachers, class_name: 'User'

  validates_uniqueness_of :name
end
