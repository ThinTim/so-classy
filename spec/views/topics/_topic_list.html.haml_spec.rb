require 'rails_helper'

describe 'topics/_topic_list.html.haml', type: :view do

  before(:each) do
    current_user = User.new(id: 22, name: 'Current', email: 'current@example.com')
    allow(view).to receive(:current_user).and_return current_user
  end

  it 'should display topics' do
    owner = User.new(id: 42, name: 'Phil', email: 'phil@example.com')

    render partial: 'topics/topic_list', locals: { topics: [Topic.new(id: 1, name: 'Tropical Topic', owner: owner)] }

    # Name
    expect(rendered).to include 'Tropical Topic'

    # Owner
    expect(rendered).to include 'Phil'
  end

end