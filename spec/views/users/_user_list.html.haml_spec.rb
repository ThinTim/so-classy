require 'rails_helper'

describe 'users/_user_list.html.haml', type: :view do

  it 'should display users' do
    render partial: 'users/user_list', locals: { users: [User.new(id: 1, name: 'Jimmy', email: 'jimmy@example.com')] }

    # Names
    expect(rendered).to include 'Jimmy'

    # Emails
    expect(rendered).to include 'jimmy@example.com'

    # Avatars
    assert_select('img[alt*="Jimmy"]')
  end

end