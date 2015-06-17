require 'rails_helper'

describe 'users/show.html.haml', type: :view do

  before(:each) do
    @user = User.create(name: 'Mick', email: 'mick@example.com') 
    assign(:user, @user)
    allow(view).to receive(:current_user).and_return(@user)
    allow(view).to receive(:current_user?).with(@user).and_return(true)
    allow(view).to receive(:current_user?).with(any_args).and_return(false)
  end

  it 'should display the user\'s name and email' do
    render

    expect(rendered).to include @user.name
    expect(rendered).to include @user.email
  end

end