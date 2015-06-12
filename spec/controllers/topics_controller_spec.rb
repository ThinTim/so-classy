require 'rails_helper'

describe TopicsController, type: :controller do

  before(:each) do 
    @current_user = User.create(email: 'jimmy@example.com')
    session[:user_id] = @current_user.id
  end

  describe 'GET #index' do

    it 'should return status 200' do
      get :index

      expect(response.status).to eq 200
    end

    it 'should list all topics' do
      testing_topic = Topic.create

      get :index

      expect(assigns(:topics)).to include testing_topic
    end

    it 'should sort by popularity (descending) by default' do
      t0 = Topic.create(name: '0')
      t1 = Topic.create(name: '1')
      t2 = Topic.create(name: '2')

      u1 = User.create(email: 'geordi@example.com')
      u2 = User.create(email: 'worf@example.com')

      t2.teachers << u1
      t2.teachers << u2
      t1.students << u2

      get :index

      expect(assigns(:topics)).to eq [t2, t1, t0]
    end

    it 'should sort by requested field' do
      tb = Topic.create(name: 'b')
      tx = Topic.create(name: 'x')
      ta = Topic.create(name: 'a')

      get :index, order_by: 'name', direction: 'ascending'

      expect(assigns(:topics)).to eq [ta, tb, tx]
    end

  end

  describe 'GET #new' do

    it 'should return status 200' do
      get :new

      expect(response.status).to eq 200
    end

  end

  describe 'POST #create' do

    context 'when when topic is new' do

      it 'should store the new topic' do
        post :create, topic: {
            name: 'Knife fighting'
        }

        expect(assigns(:topic).name).to eq 'Knife fighting'
      end

      it 'should store the description of the topic if provided' do
        post :create, topic: {
            name: 'Knife making',
            description: 'Tired of cutting steak with a spoon? Then we\'ve got the course for you!'
        }

        topic = Topic.find_by_name('Knife making')

        expect(assigns(:topic).description).to start_with 'Tired'
      end

      it 'should set the owner of the new topic' do
        post :create, topic: {
            name: 'Knife juggling'
        }

        topic = Topic.find_by_name('Knife juggling')

        expect(topic.owner.id).to eq @current_user.id
      end

      it 'should redirect to the new topic' do
        post :create, topic: {
            name: 'Knife knitting'
        }

        assert_redirected_to assigns(:topic)
      end

    end

    context 'when when topic already exists' do

      before(:each) do
        @existing_topic = Topic.create({ name: 'Duplicating' })
      end

      it 'should redirect the user to the topic' do
        post :create, topic: {
            name: 'Duplicating'
        }

        assert_redirected_to(@existing_topic)
      end

      it 'should not create a duplicate topic' do
        assert_difference 'Topic.count', 0 do
          post :create, topic: { name: 'Duplicating' }
        end
      end

    end

  end

  describe 'GET #show' do

    let(:topic) { Topic.create({ name: 'Banjo' }) }

    it 'should make the topic available' do
      get :show, id: topic.id

      expect(assigns(:topic)).to eq topic
    end

  end

  describe 'PATCH #update' do
    before(:each) do
      @other_user = User.create(email: 'george@example.com')
      @topic = Topic.create(name: 'Bowling', owner: @current_user)
    end

    it 'should not let you change a topic you don\'t own' do
      @topic.owner = @other_user
      @topic.save

      patch :update, id: @topic.id, topic: { name: 'Rolling' }

      @topic.reload

      expect(@topic.name).to eq 'Bowling'
    end

    it 'should update the topic name' do
      patch :update, id: @topic.id, topic: { name: 'Rolling' }

      @topic.reload

      expect(@topic.name).to eq 'Rolling'
    end

    it 'should update the topic description' do
      patch :update, id: @topic.id, topic: { description: 'Not rolling' }

      @topic.reload

      expect(@topic.description).to eq 'Not rolling'
    end

  end

  describe 'DELETE #destroy' do

    let(:owner) { User.create(email: 'barry@example.com') }
    let(:non_owner) { User.create(email: 'otherbarry@example.com') }

    before :each do
      @topic = Topic.create({ name: 'Banjo', owner: owner })
    end

    context 'current_user is owner' do

      before :each do
        session[:user_id] = owner.id
      end

      it 'should delete the topic' do
        assert_difference('Topic.count', -1) { delete :destroy, id: @topic.id }
      end

      it 'should redirect to topics index' do
        delete :destroy, id: @topic.id

        assert_redirected_to :topics
      end

    end

    context 'current_user is not owner' do

      before :each do
        session[:user_id] = non_owner.id
      end

      it 'should not delete the topic' do
        assert_difference('Topic.count', 0) { delete :destroy, id: @topic.id }
      end

      it 'should redirect to show' do
        delete :destroy, id: @topic.id

        assert_redirected_to @topic
      end

    end

  end

  describe 'POST #add_teacher' do

    before(:each) do
      @existing_topic = Topic.create(name: 'Jimmying')
    end
    
    it 'should add current user to teachers' do
      post :add_teacher, id: @existing_topic.id

      @existing_topic.reload

      expect(@existing_topic.teachers).to include @current_user
    end

    it 'should reload page' do
      post :add_teacher, id: @existing_topic.id

      assert_redirected_to @existing_topic
    end

    context 'when the user is already a teacher' do

      before(:each) do
        @existing_topic.teachers << @current_user
        @existing_topic.save!
      end

      it 'should return status 409' do
        post :add_teacher, id: @existing_topic.id

        expect(response.status).to eq 409
      end

      it 'should prevent duplicates' do
        assert_difference '@existing_topic.teachers.size', 0 do
          post :add_teacher, id: @existing_topic.id

          @existing_topic.reload
        end
      end

    end

  end

  describe 'POST #remove_teacher' do

    before(:each) do
      @existing_topic = Topic.create(name: 'Jimmying')
      @existing_topic.teachers << @current_user
      @existing_topic.save!
    end

    it 'should remove the user from the list of teachers' do
      session[:user_id] = @current_user.id

      post :remove_teacher, id: @existing_topic.id

      @existing_topic.reload

      expect(@existing_topic.teachers).not_to include @current_user
    end

  end

  describe 'POST #add_student' do

    before :each do
      @existing_topic = Topic.create(name: 'Jimmying')
    end

    it 'should add current user to learners' do
      post :add_student, id: @existing_topic.id

      expect(@existing_topic.students).to include @current_user
    end

    it 'should reload page' do
      post :add_teacher, id: @existing_topic.id

      assert_redirected_to @existing_topic
    end

    context 'when the user is already a student' do

      before(:each) do
        @existing_topic.students << @current_user
        @existing_topic.save!
      end

      it 'should return status 409' do
        post :add_student, id: @existing_topic.id

        expect(response.status).to eq 409
      end

      it 'should prevent duplicates' do
        assert_difference '@existing_topic.students.size', 0 do
          post :add_student, id: @existing_topic.id

          @existing_topic.reload
        end
      end

    end

  end

  describe 'POST #remove_student' do

    before(:each) do
      @existing_topic = Topic.create(name: 'Jimmying')
      @existing_topic.students << @current_user
      @existing_topic.save!
    end

    it 'should remove the user from the list of students' do
      session[:user_id] = @current_user.id

      post :remove_student, id: @existing_topic.id

      @existing_topic.reload

      expect(@existing_topic.students).not_to include @current_user
    end

  end
  
end