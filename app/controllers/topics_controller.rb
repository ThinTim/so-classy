class TopicsController < ApplicationController

  def new
  end

  def index
    @topics = Topic.all
  end

  def create
    @topic = Topic.create!(topic_params)
    redirect_to @topic
  rescue ActiveRecord::RecordInvalid
    existing_topic = Topic.find_by_name(topic_params['name'])
    redirect_to(existing_topic) unless existing_topic.nil?
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def add_teacher
    topic = Topic.find(params[:id])
    topic.teachers << current_user
    topic.save!
    redirect_to(topics_url)
  end

private

  def topic_params
    params.require(:topic).permit(:name)
  end

end
