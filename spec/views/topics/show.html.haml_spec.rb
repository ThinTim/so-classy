require 'rails_helper'

describe 'topics/show.html.haml', type: :view do

  let(:morty_owner) { User.new(id: 44, name: 'Morty', email: 'morty@example.com') }
  let(:rick_non_owner) { User.new(id: 43, name: 'Rick', email: 'rick@example.com') }
  let(:topic) { Topic.new(name: 'Topic Name', id: 42, owner: morty_owner, description: 'Yep, it\'s a topic') }

  before(:each) do
    allow(view).to receive(:current_user)
    allow(view).to receive(:current_user?)

    allow(view).to receive(:topic_json).and_return(topic.to_json)

    assign(:topic, topic)
  end

  it 'should display topic name' do
    render

    expect(rendered).to include 'Topic Name'
  end

  it 'should display topic description' do
    render

    expect(rendered).to include 'Yep, it\'s a topic'
  end

end