require 'rails_helper'

describe CommentsController, type: :controller do
  before(:each) do
    @fry = User.create(name: 'Fry', email: 'fry@example.com')
    @professor = User.create(name: 'Hubert', email: 'hubert@example.com')

    @main_topic = Topic.create!(name: 'The mathematics of quantum neutrino fields')
    @main_topic.comments << Comment.create!(author: @professor, body: 'This is an impossible topic')
    @main_topic.save!

    @other_topic = Topic.create!(name: 'The mathematics of wonton burrito meals')
    @other_topic.comments << Comment.create!(author: @fry, body: 'This is a cakewalk')
    @other_topic.save!

    session[:user_id] = @fry.id
  end

  describe 'index' do
    it 'should find comments matching the provided topic id' do
      get :index, topic_id: @main_topic.id

      expect(assigns(:comments)).to eq(@main_topic.comments)
    end
  end

  describe 'create' do
    it 'should add the comment to the topic' do
      assert_difference '@main_topic.comments.size' do
        post :create, topic_id: @main_topic.id, comment: { body: 'The body' }

        @main_topic.reload
      end
    end      

    it 'should redirect to topic#show' do
      post :create, topic_id: @main_topic.id, comment: { body: 'The body' }
      
      assert_redirected_to @main_topic
    end
  end

  describe 'destroy' do
    it 'should delete the comment' do
      assert_difference '@other_topic.comments.size', -1 do
        post :destroy, topic_id: @other_topic.id, id: @other_topic.comments.first.id

        @other_topic.reload
      end
    end

    it 'should redirect to the topic' do
      post :destroy, topic_id: @other_topic.id, id: @other_topic.comments.first.id

      assert_redirected_to @other_topic
    end

    it 'should not let you delete comments made by other users' do
      assert_difference '@main_topic.comments.size', 0 do
        post :destroy, topic_id: @main_topic.id, id: @main_topic.comments.first.id

        @main_topic.reload
      end
    end
  end
end
