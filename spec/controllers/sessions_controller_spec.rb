require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'get #new' do
    it 'should not require the user to log in' do
      expect(controller).not_to receive(:authenticate_user)

      get :new
    end

    it 'should render a view' do
      get :new

      assert_template :new
    end
  end
end
