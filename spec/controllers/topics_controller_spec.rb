require 'rails_helper'

describe TopicsController, type: :controller do

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

  end

  describe 'GET #new' do

    it 'should return status 200' do
      get :new

      expect(response.status).to eq 200
    end

  end

  describe 'POST #create' do

    context 'when topic is new' do

      it 'should store the new topic' do
        post :create, topic: {
            name: 'Knife fighting'
        }

        expect(assigns(:topic).name).to eq 'Knife fighting'
      end

      it 'should redirect to the new topic' do
        post :create, topic: {
            name: 'Knife knitting'
        }

        assert_redirected_to assigns(:topic)
      end

    end

    context 'when topic already exists' do

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

  describe 'POST #add_teacher' do
    context 'the user is logged in' do
      before(:each) do
        @existing_topic = Topic.create(name: 'Jimmying')
        @current_user = User.create(name: 'Jimmy')
        session[:user_id] = @current_user.id
      end
      
      it 'should add current user to teachers' do
        post :add_teacher, id: @existing_topic.id

        expect(@existing_topic.teachers).to include @current_user
      end

      it 'should reload page' do
        post :add_teacher, id: @existing_topic.id

        assert_redirected_to @existing_topic
      end

      xcontext 'the user is already a teacher' do
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
          end
        end
      end
    end
  end

  describe 'POST #add_student' do
    context 'the user is logged in' do
      before :each do
        @existing_topic = Topic.create(name: 'Jimmying')
        @current_user = User.create(name: 'Jimmy')
        session[:user_id] = @current_user.id
      end

      it 'should add current user to learners' do
        post :add_student, id: @existing_topic.id

        expect(@existing_topic.students).to include @current_user
      end

      it 'should reload page' do
        post :add_teacher, id: @existing_topic.id

        assert_redirected_to @existing_topic
      end

      xcontext 'the user is already a student' do
        before(:each) do
          @existing_topic.students << @current_user
          @existing_topic.save!
        end

        it 'should return status 409' do
          post :add_teacher, id: @existing_topic.id

          expect(response.status).to eq 409
        end

        it 'should prevent duplicates' do
          assert_difference '@existing_topic.students.size', 0 do
            post :add_student, id: @existing_topic.id
          end
        end
      end
    end
  end

end
