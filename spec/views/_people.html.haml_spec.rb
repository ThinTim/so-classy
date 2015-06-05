require 'rails_helper'

describe '_people.html.haml', type: :view do

  it 'should display people' do
    render partial: 'people', locals: { people: [User.new(name: 'Jimmy', email: 'jimmy@example.com')] }

    # Names
    expect(rendered).to include 'Jimmy'

    # Emails
    expect(rendered).to include 'jimmy@example.com'

    # Avatars
    assert_select('img[alt="Jimmy"]')
  end

end