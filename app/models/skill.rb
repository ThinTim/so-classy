class Skill < ActiveRecord::Base

  def to_s
    name
  end

  def inspect
    "<Skill:#{name}>"
  end
end
