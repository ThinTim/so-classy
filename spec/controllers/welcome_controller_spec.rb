require 'rails_helper'

describe WelcomeController, type: :controller do

  describe 'GET #index' do

    context 'when there is no session cookie' do

      it 'should redirect to users/new' do
        get :index

        assert_redirected_to(controller: :users, action: :new)
      end

    end

    context 'when there is a user_id cookie' do

      before :each do
        @user = User.create(name: 'Jim', email: 'jim@example.com')
        cookies['user_id'] = @user.id
      end

      it 'should redirect to user stored in cookie' do
        get :index

        assert_redirected_to(@user)
      end

    end

  end

end
