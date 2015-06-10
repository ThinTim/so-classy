require 'rails_helper'

describe 'application/_auth.html.haml', type: :view do

  context 'when the user is logged in' do

    before(:each) do
      @user = User.new email: 'tim@example.com'

      allow(view).to receive(:current_user).and_return(@user)
      
      render
    end

    it 'should display the logout button' do
      expect(rendered).to include 'Logout'
    end

  end

  context 'when the user is not logged in' do
    
    before(:each) do
      allow(view).to receive(:current_user).and_return(nil)

      render
    end

    it 'should display the login form' do
      assert_select('input[type="email"][name="email"]')
      assert_select('button[type="submit"]')
    end

  end

end