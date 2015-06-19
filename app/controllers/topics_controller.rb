class TopicsController < ApplicationController

  before_filter :correct_user, only: [ :edit, :update ]

  def new
    @topic = Topic.new(name: params[:prefill]) if params[:prefill]
  end

  def index
    query = search_params

    query[:sort] ||= 'popularity'
    query[:direction] ||= 'descending'
    query[:name] ||= ''

    query[:sort].downcase!
    query[:direction].downcase!
    query[:name].downcase!

    if query.permitted?
      sort = query[:sort].to_sym if ['name', 'popularity'].include? query[:sort]
      direction = query[:direction].to_sym if ['ascending', 'descending'].include? query[:direction]
    end

    @topics = Topic.where('lower(name) LIKE ?', "%#{query[:name]}%").sort_by(&sort)

    if(direction == :descending)
      @topics = @topics.reverse
    end

    respond_to do |format|
      format.html 
      format.json { render json: @topics.map { |t| topic_json(t) } }
    end
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.owner = current_user
    @topic.save!

    redirect_to @topic
  rescue ActiveRecord::RecordInvalid
    existing_topic = Topic.find_by_name(topic_params['name'])
    redirect_to(existing_topic) unless existing_topic.nil?
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])

    @topic.update_attributes(topic_params)

    @topic.save!

    flash[:success] = 'Topic updated'

    redirect_to topic_path(@topic)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Validation failed!"

    redirect_to edit_topic_path(@topic)
  end

  def destroy
    topic = Topic.find(params[:id])
    if current_user == topic.owner
      topic.destroy!
      flash[:success] = 'Topic deleted'
      redirect_to :topics
    else
      flash[:error] = 'Only the creator of a topic can delete it'
      redirect_to topic
    end
  end

  def add_teacher
    topic = Topic.find(params[:id])
    topic.teachers << current_user
    topic.save!

    respond_to do |format|
      format.html { redirect_to(topic) }
      format.json { render json: topic.teachers }
    end
  rescue ActiveRecord::RecordInvalid
    render nothing: true, status: 409
  end

  def remove_teacher
    topic = Topic.find(params[:id])
    topic.teachers.delete(current_user)
    topic.save!

    respond_to do |format|
      format.html { redirect_to(topic) }
      format.json { render json: topic.teachers }
    end
  end

  def add_student
    topic = Topic.find(params[:id])
    topic.students << current_user
    topic.save!

    respond_to do |format|
      format.html { redirect_to(topic) }
      format.json { render json: topic.students }
    end
  rescue ActiveRecord::RecordInvalid
    render nothing: true, status: 409
  end

  def remove_student
    topic = Topic.find(params[:id])
    topic.students.delete(current_user)
    topic.save!

    respond_to do |format|
      format.html { redirect_to(topic) }
      format.json { render json: topic.students }
    end
  end

private

  def topic_params
    params.require(:topic).permit(:name, :description)
  end

  def search_params
    params.permit(:sort, :direction, :name)
  end

  def correct_user
    @topic = Topic.find(params[:id])
    if not current_user?(@topic.owner)
      flash[:error] = 'Can not update the selected topic'
      redirect_to :root
    end
  end

  def topic_json(topic)
    topic.as_json.merge({
      owner: topic.owner.as_json.merge({ routes: { show: user_path(topic.owner) } }),
      isTeaching: topic.teachers.include?(current_user),
      isLearning: topic.students.include?(current_user),
      teacherCount: topic.teachers.size,
      studentCount: topic.students.size,
      routes: {
        show: topic_path(topic),
        teach: add_teacher_topic_path(topic), 
        stopTeaching: remove_teacher_topic_path(topic),
        learn: add_student_topic_path(topic), 
        stopLearning: remove_student_topic_path(topic)
      }
    })
  end

end
