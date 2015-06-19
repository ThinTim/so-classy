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

    comment = Comment.new(params.require(:comment).permit(:body))
    comment.author = current_user

    topic.comments << comment
    topic.save!

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

  def correct_user
    comment = Comment.find(params[:id])

    if not current_user?(comment.author)
      flash[:error] = 'Can not update comments made by other users'
      redirect_to :root
    end
  end
end
