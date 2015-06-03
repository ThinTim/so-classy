class Skill < ActiveRecord::Base
  validates :name, uniqueness: true
end
