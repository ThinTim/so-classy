class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_filter :authenticate_user

  helper_method :current_user
  helper_method :current_user?

  helper_method :topic_json

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id]) if @current_user.nil?
    end
    @current_user
  end

  def current_user?(user)
    return !user.nil? && current_user == user
  end

  def user_json(user)
    user.as_json.merge({
      gravatar_url: gravatar_url(user.email, size=50),
      routes: {
        show: user_path(user)
      }
    })
  end

  def comment_json(topic, comment)
    comment.as_json.merge(
      author: user_json(comment.author),
      isAuthor: current_user?(comment.author),
      routes: {
        destroy: topic_comment_path(topic, comment)
      }
    )
  end

  def topic_json(topic)
    topic.as_json.merge({
      owner: user_json(topic.owner),
      isTeaching: topic.teachers.include?(current_user),
      isLearning: topic.students.include?(current_user),
      member_count: topic.members.size,
      teachers: topic.teachers.sort_by(&:display_name).map { |u| user_json(u) },
      students: topic.students.sort_by(&:display_name).map { |u| user_json(u) },
      comments: topic.comments.sort_by(&:created_at).reverse.map { |c| comment_json(topic, c) },
      routes: {
        show: topic_path(topic),
        teach: add_teacher_topic_path(topic), 
        stopTeaching: remove_teacher_topic_path(topic),
        learn: add_student_topic_path(topic), 
        stopLearning: remove_student_topic_path(topic),
        comments: topic_comments_path(topic)
      }
    })
  end

  protected

  def json_request?
    request.format.json?
  end

  def authenticate_user
    if current_user.nil?
      flash[:danger] = 'Please log in'
      redirect_to(:root)
    end
  end

  def gravatar_url(email_address, size=80)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email_address.strip.downcase)}?s=#{size}&d=mm"
  end
end
