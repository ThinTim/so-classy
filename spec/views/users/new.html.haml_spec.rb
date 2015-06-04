require 'rails_helper'

describe 'users/new.html.haml', type: :view do

  it 'should contain a form' do
    render

    assert_select('form[action="/users/login"][method="post"]')
    assert_select('input[type="text"][name="user[name]"]')
    assert_select('input[type="email"][name="user[email]"]')
    assert_select('input[type="submit"]')
  end

end