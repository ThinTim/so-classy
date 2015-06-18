require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'get #new' do
    it 'should not require the user to log in' do
      expect(controller).not_to receive(:authenticate_user)

      get :new
    end

    it 'should render a view if the user is not logged in' do
      get :new

      assert_template :new
    end

    it 'should redirect to topics path if the user is logged in' do
      user = User.create(email: 'fred@example.com')
      session[:user_id] = user.id

      get :new

      assert_redirected_to topics_path
    end
  end

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

      it 'should reset the user\'s token' do
        expect {
          get :authenticate, id: @existing_user.id, token: @existing_user.token

          @existing_user.reload
        }.to change { @existing_user.token }
      end

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

  describe 'POST #create' do

    let(:fake_mail) { double() }

    before(:each) do
      allow(fake_mail).to receive(:deliver_later)
      allow(UserMailer).to receive(:sign_in).and_return(fake_mail)
    end

    it 'should not require the user to log in' do
      expect(controller).not_to receive(:authenticate_user)

      post :create, email: 'dave@example.com'
    end

    context 'when when user is new' do

      it 'should create user' do
        assert_difference 'User.count', 1 do
          post :create, email: 'dave@example.com'
        end

        user = User.find_by_email('dave@example.com')
        expect(user.token).not_to be_nil
      end

      it 'should send an email to the user' do
        post :create, email: 'dave@example.com'

        user = User.find_by_email('dave@example.com')
        expect(UserMailer).to have_received(:sign_in).with(user).once
        expect(fake_mail).to have_received(:deliver_later)
      end

      it 'should redirect to root' do
        post :create, email: 'dave@example.com'

        assert_redirected_to(:root)
      end

    end

    context 'when when user already exists' do

      before :each do
        @existing_user = User.create(email: 'dave@example.com', token: SecureRandom.hex )
      end

      it 'should not create user' do
        assert_difference 'User.count', 0 do
          post :create, email: 'dave@example.com'
        end
      end

      it 'should generate new token' do
        starting_token = @existing_user.token

        post :create, email: 'dave@example.com'

        @existing_user.reload
        expect(@existing_user.token).not_to be_nil
        expect(@existing_user.token).not_to eq starting_token
      end

      it 'should send an email to the user' do
        post :create, email: 'dave@example.com'

        expect(UserMailer).to have_received(:sign_in).with(@existing_user).once
        expect(fake_mail).to have_received(:deliver_later)
      end

      it 'should redirect to root' do
        post :create, email: 'dave@example.com'

        assert_redirected_to(:root)
      end

    end

    context 'when the user is invalid' do

      it 'should redirect to root' do
        post :create, email: 'dave@invalid.com'

        assert_redirected_to(:root)
      end

      it 'should flash validation message' do
        post :create, email: 'dave@invalid.com'

        expect(flash[:error]).not_to be_nil
      end

    end

  end

  describe 'GET #destroy' do
    before :each do
      @current_user = User.create(email: 'paul@example.com')
      session[:user_id] = @current_user.id
    end

    it 'should reset the session' do
      get :destroy

      expect(session[:user_id]).to be_nil
    end

    it 'should redirect to root' do
      get :destroy

      assert_redirected_to(:root)
    end
  end
end
