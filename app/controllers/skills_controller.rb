class SkillsController < ApplicationController
  def new
  end

  def index
    @skills = Skill.all
  end

  def create
    existing = Skill.find_by_name(skill_params["name"])

    if existing != nil
      render :nothing => true, :status => :ok
    else
      @skill = Skill.new(skill_params)
      @skill.save
      render :nothing => true, :status => :created
    end
  end

  private
    def skill_params
      params.require(:skill).permit(:name)
    end
end
