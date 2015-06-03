require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET #new' do
    it 'should return status 200' do
      get :new

      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do

    it 'should create user_id cookie' do
      post :create, user: { name: 'Dave', email: 'dave@example.com' }

      expect(cookies[:user_id]).to eq assigns(:user).id
    end

    context 'when user is new' do

      it 'should create user' do
        assert_difference 'User.count', 1 do
          post :create, user: { name: 'Dave', email: 'dave@example.com' }
        end

        expect(assigns(:user).name).to eq 'Dave'
        expect(assigns(:user).email).to eq 'dave@example.com'
      end

      it 'should redirect to created user' do
        post :create, user: { name: 'Dave', email: 'dave@example.com' }

        assert_redirected_to(assigns(:user))
      end

    end

    context 'when user already exists' do

      before :each do
        @existing_user = User.create(name: 'Dave', email: 'dave@example.com')
      end

      it 'should not create user' do
        assert_difference 'User.count', 0 do
          post :create, user: { name: 'Dave', email: 'dave@example.com' }
        end
      end

      it 'should redirect to existing user' do
        post :create, user: { name: 'Dave', email: 'dave@example.com' }
        assert_redirected_to(@existing_user)
      end

    end

  end

  describe 'GET #show' do

    let(:user) { User.create(name: 'Barry', email: 'barry@example.com') }

    it 'should assign user' do
      get :show, id: user.id

      expect(assigns(:user)).to eq user
    end

  end

end
