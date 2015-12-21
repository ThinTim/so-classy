class CommentsController < ApplicationController
  before_filter :correct_user, only: [ :destroy ]

  def index
    topic = Topic.find(params[:topic_id])
    @comments = topic.comments

    respond_to do |format|
      format.html
      format.json { render json: @comments.sort_by(&:created_at).reverse.map { |c| comment_json(topic, c) } }
    end
  end

  def create
    topic = Topic.find(params[:topic_id])

    comment = Comment.new(body: comment_params[:body])
    comment.author = current_user

    topic.comments << comment
    topic.save!

    UserMailer.email_comment(comment, topic).deliver_later if comment_params[:sendEmail] == 'true'

    respond_to do |format|
      format.html { redirect_to topic }
      format.json { render json: topic.comments.sort_by(&:created_at).reverse.map { |c| comment_json(topic, c) } }
    end
  end

  def destroy
    topic = Topic.find(params[:topic_id])

    comment = Comment.find(params[:id])

    comment.destroy!

    respond_to do |format|
      format.html { 
        flash[:success] = 'Comment deleted'
        redirect_to topic
      }
      format.json { 
        topic.reload
        render json: topic.comments.sort_by(&:created_at).reverse.map { |c| comment_json(topic, c) } 
      }
    end

    
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :sendEmail)
  end

  def correct_user
    comment = Comment.find(params[:id])

    if not current_user?(comment.author)
      flash[:error] = 'Can not update comments made by other users'
      redirect_to :root
    end
  end
end
