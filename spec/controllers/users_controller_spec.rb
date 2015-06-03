require 'rails_helper'

describe UsersController, type: :controller do

  describe 'POST #create' do

    context 'when user is new' do

      it 'should create user' do
        assert_difference 'User.count', 1 do
          post :create, user: { name: 'Dave', email: 'dave@example.com' }
        end

        expect(assigns(:user).name).to eq 'Dave'
        expect(assigns(:user).email).to eq 'dave@example.com'
      end

      it 'should create user_id cookie' do
        post :create, user: { name: 'Dave', email: 'dave@example.com' }

        expect(cookies[:user_id]).to eq assigns(:user).id
      end

      it 'should redirect to root' do
        post :create, user: { name: 'Dave', email: 'dave@example.com' }

        assert_redirected_to(:root)
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

      it 'should create user_id cookie' do
        post :create, user: { name: 'Dave', email: 'dave@example.com' }

        expect(cookies[:user_id]).to eq @existing_user.id
      end

      it 'should redirect to root' do
        post :create, user: { name: 'Dave', email: 'dave@example.com' }

        assert_redirected_to(:root)
      end

    end

  end

end
