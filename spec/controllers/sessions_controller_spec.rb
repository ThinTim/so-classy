require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'get #new' do
    it 'should render a view' do
      get :new

      assert_template :new
    end
  end
end
