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

    context 'when the user is logged in' do 
      it 'should return status 200' do
        session[:user_id] = 1

        get :new

        expect(response.status).to eq 200
      end
    end

    context 'when the user is logged out' do
      it 'should redirect to root' do
        get :new

        assert_redirected_to :root
      end
    end

  end

  describe 'POST #create' do

    context 'when user is logged in' do

      before :each do
        session[:user_id] = 42
      end

      context 'when when topic is new' do

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

    context 'when user is not logged in' do

      it 'should redirect to root' do
        post :create, topic: { name: 'Doomed topic' }

        assert_redirected_to :root
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
    context 'when the user is logged in' do
      before(:each) do
        @existing_topic = Topic.create(name: 'Jimmying')
        @current_user = User.create(email: 'jimmy@example.com')
        session[:user_id] = @current_user.id
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

    context 'when the user is logged out' do
      before :each do
        @existing_topic = Topic.create(name: 'Teaching')
      end

      it 'should not alter the teacher list' do
        assert_difference '@existing_topic.teachers.size', 0 do
          post :add_teacher, id: @existing_topic.id
        end
      end

      it 'should redirect to root' do
        post :add_teacher, id: @existing_topic.id

        assert_redirected_to :root
      end
    end

  end

  describe 'POST #remove_teacher' do
    before(:each) do
      @existing_topic = Topic.create(name: 'Jimmying')
      @current_user = User.create(email: 'jimmy@example.com')
      @existing_topic.teachers << @current_user
      @existing_topic.save!
    end

    context 'when the user is logged in' do
      it 'should remove the user from the list of teachers' do
        session[:user_id] = @current_user.id

        post :remove_teacher, id: @existing_topic.id

        @existing_topic.reload

        expect(@existing_topic.teachers).not_to include @current_user
      end
    end

    context 'when the user is logged out' do
      it 'should redirect to root' do
        post :remove_teacher, id: @existing_topic.id

        assert_redirected_to :root
      end
    end
  end

  describe 'POST #add_student' do
    context 'when the user is logged in' do
      before :each do
        @existing_topic = Topic.create(name: 'Jimmying')
        @current_user = User.create(email: 'jimmy@example.com')
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

    context 'when the user is logged out' do
      before :each do
        @existing_topic = Topic.create(name: 'Jimmying')
      end

      it 'should not alter the student list' do
        assert_difference '@existing_topic.students.size', 0 do
          post :add_student, id: @existing_topic.id

          @existing_topic.reload
        end
      end

      it 'should redirect to root' do
        post :add_student, id: @existing_topic.id

        assert_redirected_to :root
      end
    end

  end

  describe 'POST #remove_student' do
    before(:each) do
      @existing_topic = Topic.create(name: 'Jimmying')
      @current_user = User.create(email: 'jimmy@example.com')
      @existing_topic.students << @current_user
      @existing_topic.save!
    end

    context 'when the user is logged in' do
      it 'should remove the user from the list of students' do
        session[:user_id] = @current_user.id

        post :remove_student, id: @existing_topic.id

        @existing_topic.reload

        expect(@existing_topic.students).not_to include @current_user
      end
    end

    context 'when the user is logged out' do
      it 'should redirect to root' do
        post :remove_student, id: @existing_topic.id

        assert_redirected_to :root
      end
    end
  end
end
