require 'rails_helper'

describe 'application/_auth.html.haml', type: :view do

  context 'when there is a current_user' do

    before(:each) do
      @user = User.new email: 'tim@example.com'

      allow(view).to receive(:current_user).and_return(@user)
      
      render
    end

    it 'should display logout link' do
      expect(rendered).to include 'Get a new sign in email'
    end

  end

  context 'when there is no current_user' do
    
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