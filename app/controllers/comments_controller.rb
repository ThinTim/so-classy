class CommentsController < ApplicationController
  before_filter :correct_user, only: [ :destroy ]

  def index
    @comments = Comment.where('topic_id = ?', params[:topic_id])
  end

  def create
    topic = Topic.find(params[:topic_id])

    comment = Comment.new(params.require(:comment).permit(:body))
    comment.author = current_user

    topic.comments << comment
    topic.save!

    redirect_to topic
  end

  def destroy
    topic = Topic.find(params[:topic_id])

    comment = Comment.find(params[:id])

    comment.destroy!

    flash[:success] = 'Comment deleted'

    redirect_to topic
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
