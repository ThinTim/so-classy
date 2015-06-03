require 'rails_helper'

describe 'users/show.html.haml', type: :view do

  it 'should display skill name' do
    user = User.new(name: 'Other Barry', email: 'other.barry@example.com')
    assign(:user, user)

    render

    expect(rendered).to include 'Other Barry'
    expect(rendered).to include 'other.barry@example.com'
  end

end