require 'rails_helper'

describe 'user_mailer/sign_in.html.haml', type: :view do

  it 'should contain a link to verify email' do
    @user = User.new(id: 42, email: 'nick@example.com', token: SecureRandom.hex )

    render

    expect(rendered).to include "users/#{@user.id}/authenticate?token=#{@user.token}"
  end

end