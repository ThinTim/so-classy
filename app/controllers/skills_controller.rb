class SkillsController < ApplicationController
  def new
  end

  def index
    @skills = Skill.all
  end

  def create
    @skill = Skill.new(skill_params)
    @skill.save!
    redirect_to @skill
  rescue ActiveRecord::RecordInvalid
    existing_skill = Skill.find_by_name(skill_params['name'])
    redirect_to(existing_skill) unless existing_skill.nil?
  end

  def show
    @skill = Skill.find(params[:id])
  end

  private
    def skill_params
      params.require(:skill).permit(:name)
    end
end
