require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET #authenticate' do

    before(:each) do
      @existing_user = User.create(email: 'max@example.com', token: SecureRandom.hex)
    end

    it 'should redirect to root' do
      get :authenticate, id: @existing_user.id, token: @existing_user.token

      assert_redirected_to :root
    end

    it 'should not require the user to log in' do
      expect(controller).not_to receive(:authenticate_user)

      get :authenticate, id: @existing_user.id, token: @existing_user.token
    end

    context 'when the token matches the user in the database' do

      it 'should reset the session' do
        session[:old_data] = 'old data'
        get :authenticate, id: @existing_user.id, token: @existing_user.token

        expect(session[:old_data]).to be_nil
      end

      it 'should add the user_id to session' do
        get :authenticate, id: @existing_user.id, token: @existing_user.token

        expect(session[:user_id]).to eq @existing_user.id
      end

    end

    context 'when the token is invalid' do

      it 'should not add the user_id to the session' do
        get :authenticate, id: @existing_user.id, token: SecureRandom.hex

        expect(session[:user_id]).to be_nil
      end

    end

  end

  describe 'POST #login' do

    let(:fake_mail) { double() }

    before(:each) do
      allow(fake_mail).to receive(:deliver_later)
      allow(UserMailer).to receive(:sign_in).and_return(fake_mail)
    end

    it 'should not require the user to log in' do
      expect(controller).not_to receive(:authenticate_user)

      post :login, email: 'dave@example.com'
    end

    context 'when when user is new' do

      it 'should create user' do
        assert_difference 'User.count', 1 do
          post :login, email: 'dave@example.com'
        end

        user = User.find_by_email('dave@example.com')
        expect(user.token).not_to be_nil
      end

      it 'should send an email to the user' do
        post :login, email: 'dave@example.com'

        user = User.find_by_email('dave@example.com')
        expect(UserMailer).to have_received(:sign_in).with(user).once
        expect(fake_mail).to have_received(:deliver_later)
      end

      it 'should redirect to root' do
        post :login, email: 'dave@example.com'

        assert_redirected_to(:root)
      end

    end

    context 'when when user already exists' do

      before :each do
        @existing_user = User.create(email: 'dave@example.com', token: SecureRandom.hex )
      end

      it 'should not create user' do
        assert_difference 'User.count', 0 do
          post :login, email: 'dave@example.com'
        end
      end

      it 'should generate new token' do
        starting_token = @existing_user.token

        post :login, email: 'dave@example.com'

        @existing_user.reload
        expect(@existing_user.token).not_to be_nil
        expect(@existing_user.token).not_to eq starting_token
      end

      it 'should send an email to the user' do
        post :login, email: 'dave@example.com'

        expect(UserMailer).to have_received(:sign_in).with(@existing_user).once
        expect(fake_mail).to have_received(:deliver_later)
      end

      it 'should redirect to root' do
        post :login, email: 'dave@example.com'

        assert_redirected_to(:root)
      end

    end

    context 'when the user is invalid' do

      it 'should redirect to root' do
        post :login, email: 'dave@invalid.com'

        assert_redirected_to(:root)
      end

      it 'should flash validation message' do
        post :login, email: 'dave@invalid.com'

        expect(flash[:error]).not_to be_nil
      end

    end

  end

  describe 'POST #logout' do
    before :each do
      session[:user_id] = 1
    end

    it 'should reset the session' do
      post :logout

      expect(session[:user_id]).to be_nil
    end

    it 'should redirect to root' do
      post :logout

      assert_redirected_to(:root)
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
