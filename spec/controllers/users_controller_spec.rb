require 'rails_helper'

describe UsersController, type: :controller do

  xdescribe 'GET #authenticate' do
    let(:link_user_id) { 1 }
    let(:link_hash) { SecureRandom.hex }

    context 'when the token matches the user in the database' do
      it 'should add the user_id to session' do
        get :authenticate, id: link_user_id, token: link_hash

        expect(session[:user_id]).to eq link_user_id
      end
    end

    context 'when the token is invalid' do
      it 'should not add the user_id to the session' do
        get :authenticate, id: link_user_id, token: link_hash

        expect(session[:user_id]).to be_nil
      end
    end
    
    it 'should redirect to root' do
      get :authenticate, id: link_user_id, token: link_hash

      assert_redirected_to :root
    end
  end

  describe 'POST #login' do

    let(:fake_mail) { double() }

    before(:each) do
      allow(fake_mail).to receive(:deliver_later)

      allow(UserMailer).to receive(:sign_in).and_return(fake_mail)
    end

    context 'when when user is new' do

      it 'should create user' do
        assert_difference 'User.count', 1 do
          post :login, user: { name: 'Dave', email: 'dave@example.com' }
        end

        expect(assigns(:user).name).to eq 'Dave'
        expect(assigns(:user).email).to eq 'dave@example.com'
        expect(assigns(:user).token).not_to be_nil
      end

      it 'should send an email to the user' do
        post :login, user: { name: 'Dave', email: 'dave@example.com' }

        user = User.find_by_email('dave@example.com')

        expect(UserMailer).to have_received(:sign_in).with(user).once
        expect(fake_mail).to have_received(:deliver_later)
      end

      it 'should redirect to root' do
        post :login, user: { name: 'Dave', email: 'dave@example.com' }

        assert_redirected_to(:root)
      end

    end

    context 'when when user already exists' do

      before :each do
        @existing_user = User.create(name: 'Dave', email: 'dave@example.com', token: SecureRandom.hex )
      end

      it 'should not create user' do
        assert_difference 'User.count', 0 do
          post :login, user: { name: 'Dave', email: 'dave@example.com' }
        end
      end

      it 'should update the users email token' do
        starting_token = @existing_user.token

        post :login, user: { name: 'Dave', email: 'dave@example.com' }

        @existing_user.reload

        expect(@existing_user.token).not_to eq starting_token
      end

      it 'should send an email to the user' do
        post :login, user: { name: 'Dave', email: 'dave@example.com' }

        expect(UserMailer).to have_received(:sign_in).with(@existing_user).once
        expect(fake_mail).to have_received(:deliver_later)
      end

      it 'should redirect to root' do
        post :login, user: { name: 'Dave', email: 'dave@example.com' }

        assert_redirected_to(:root)
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

end
