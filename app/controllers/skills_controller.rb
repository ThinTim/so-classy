class SkillsController < ApplicationController
  def new
  end

  def index
    @skills = Skill.all
  end

  def create

  end
end
