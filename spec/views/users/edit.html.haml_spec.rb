require 'rails_helper'

describe 'users/edit.html.haml', type: :view do

  let(:user) { User.create(name: 'Mick', email: 'mick@example.com') }

  it 'should display an input for the user\'s name' do
    @user = user

    render

    assert_select('input[type="text"][name="user[name]"]')
  end

end