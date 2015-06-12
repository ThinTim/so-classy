require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET #show' do
    it 'should render the correct template' do
      @current_user = User.create(email: 'max@example.com')
      session[:user_id] = @current_user.id

      get :show, id: @current_user.id

      assert_template :show
    end

    it 'should display the user' do
      @current_user = User.create(email: 'max@example.com')
      session[:user_id] = @current_user.id

      get :show, id: @current_user.id

      expect(assigns(:user)).to eq @current_user
    end
  end

  describe 'GET #edit' do
    before(:each) do
      @existing_user = User.create(email: 'max@example.com', token: SecureRandom.hex)
      session[:user_id] = @existing_user.id
    end

    it 'should display the user' do
      get :edit, id: @existing_user.id

      expect(assigns(:user)).to eq @existing_user
      assert_template :edit
    end
  end

  describe 'PUT #update' do

    before(:each) do
      @existing_user = User.create(email: 'max@example.com', token: SecureRandom.hex)
      session[:user_id] = @existing_user.id
    end

    it 'should update the user\'s name' do
      put :update, id: @existing_user.id, user: { name: 'Max' }

      @existing_user.reload

      expect(@existing_user.name).to eq 'Max'
    end

    it 'should redirect to root' do
      put :update, id: @existing_user.id, user: { name: 'Max' }

      assert_redirected_to :root
    end

    it 'should not allow updates to other users' do
      @other_user = User.create(email: 'bob@example.com')

      put :update, id: @other_user.id, user: { name: 'Max' }

      @existing_user.reload

      expect(@existing_user.name).to_not eq 'Max'
    end
  end

end
